import test from "node:test";
import assert from "node:assert/strict";
delete process.env.OPENROUTER_API_KEY; delete process.env.OPENAI_API_KEY;
const { filterCases, toCsv, buildInsights } = await import("../wave59a.mjs");
const rows=[{reference:"L-1",subject:"Qual file",state:"intake",risk:"High",amount:0,workflow_id:"qualification"},{reference:"L-2",subject:"Rent file",state:"closed",risk:"Low",amount:50,workflow_id:"rent"}];
test("filterCases search/filter",()=>{ assert.equal(filterCases(rows,{q:"qual"}).length,1); assert.equal(filterCases(rows,{state:"closed"}).length,1); assert.equal(filterCases(rows,{risk:"High"})[0].amount,0); });
test("toCsv header on empty",()=>{ assert.equal(toCsv([],["a","b"]),"a,b\n"); });
test("buildInsights fallback preserves false/0/empty",()=>{ const r=buildInsights(rows,"portfolio-summary"); assert.equal(r.aiGenerated,false); const e=buildInsights([],"next-actions"); assert.equal(e.sections.find(s=>s.label==="Empty result preserved").value,true); });
