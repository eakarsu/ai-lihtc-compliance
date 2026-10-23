// Wave 59A: search/filter, CSV/JSON export, deterministic offline LIHTC insights. No provider calls.
export function filterCases(rows, { q = "", status = "", state = "", risk = "", workflow = "" } = {}) {
  const needle = String(q || "").trim().toLowerCase();
  const st = String(status || state || "");
  return (rows || []).filter((r) => {
    if (st && String(r.state || r.status || "") !== st) return false;
    if (risk && String(r.risk || "") !== risk) return false;
    if (workflow && String(r.workflow_id || "") !== workflow) return false;
    if (!needle) return true;
    return [r.reference, r.subject, r.owner, r.state, r.risk, r.workflow_id, JSON.stringify(r.payload ?? "")].join(" ").toLowerCase().includes(needle);
  });
}
export function toCsv(rows, columns) {
  const esc = (v) => { if (v === null || v === undefined) return ""; const s = typeof v === "object" ? JSON.stringify(v) : String(v); return /[",\n\r]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s; };
  const head = columns.join(","); const body = (rows || []).map(r => columns.map(c => esc(r[c])).join(",")).join("\n"); return head + "\n" + body + (body ? "\n" : "");
}
export const EXPORT_COLUMNS = ["id","workflow_id","reference","subject","owner","state","risk","due_date","amount","created_at"];
export function buildInsights(records, kind) {
  const rows = records || []; const total = rows.reduce((s,r)=>s+Number(r.amount||0),0);
  const high = rows.filter(r=>["High","Critical"].includes(String(r.risk||""))).length;
  const open = rows.filter(r=>!["approved","closed"].includes(String(r.state||"").toLowerCase())).length;
  const zero = rows.filter(r=>Number(r.amount||0)===0).length;
  const base = { aiGenerated:false, fallback:true, source:"deterministic-fallback", label:"Deterministic fallback (offline) — not AI-generated", kind, recordCount:rows.length };
  if (kind === "risk-triage") return { ...base, headline:"LIHTC compliance — risk triage (deterministic fallback)", sections:[{label:"Record count",value:rows.length,detail:`${rows.length} workflow case(s) in scope.`},{label:"High or critical risk",value:high,detail:`${high} case(s) need priority review.`},{label:"Open items",value:open,detail:`${open} case(s) not approved/closed.`},{label:"Zero-amount preserved",value:zero,detail:`${zero} zero-amount case(s) retained.`}], metrics:[{label:"Records",value:rows.length},{label:"High risk",value:high},{label:"Open",value:open}], actions: high>0?["Review High/Critical LIHTC files first","Verify income/rent evidence"]:["Continue routine compliance review"] };
  if (kind === "next-actions") return { ...base, headline:"LIHTC compliance — next actions (deterministic fallback)", sections:[{label:"Total represented value",value:total,detail:`Total amount ${total}.`},{label:"Has open work",value:open>0,detail:open>0?`${open} open case(s).`:"No open cases."},{label:"Empty result preserved",value:rows.length===0,detail:rows.length===0?"Empty set reported explicitly.":"Cases present."}], metrics:[{label:"Total value",value:total},{label:"Open",value:open}], actions: open>0?["Work cases in due-date order","Complete recertification checks"]:["No pending actions"] };
  return { ...base, headline:"LIHTC compliance — portfolio summary (deterministic fallback)", sections:[{label:"Record count",value:rows.length,detail:`${rows.length} case(s) summarised.`},{label:"Total represented value",value:total,detail:`Total ${total}.`},{label:"Open items",value:open,detail:`${open} open.`},{label:"Zero-amount preserved",value:zero,detail:`Zero values preserved (count ${zero}).`}], metrics:[{label:"Records",value:rows.length},{label:"Total value",value:total},{label:"High risk",value:high}], actions:["Validate tenant files","Confirm applicable-fraction evidence"] };
}
export function mountWave59a(app, { pool }) {
  app.get("/api/records/export", async (req, res, next) => { try { const rows=(await pool.query("SELECT * FROM workflow_cases ORDER BY due_date,id")).rows; const f=filterCases(rows, req.query||{}); const fmt=String(req.query.format||"json").toLowerCase(); if(fmt==="csv"){ res.setHeader("Content-Type","text/csv; charset=utf-8"); res.setHeader("Content-Disposition",'attachment; filename="lihtc-records.csv"'); return res.send(toCsv(f, EXPORT_COLUMNS)); } return res.json({ aiGenerated:false, count:f.length, items:f }); } catch(e){ next(e); } });
  for (const kind of ["portfolio-summary","risk-triage","next-actions"]) app.post(`/api/ai/fallback/${kind}`, async (req,res,next)=>{ try{ const rows=(await pool.query("SELECT * FROM workflow_cases ORDER BY due_date,id LIMIT 500")).rows; return res.json({ result: buildInsights(rows, kind) }); }catch(e){ next(e); } });
}
