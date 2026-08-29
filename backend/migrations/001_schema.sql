CREATE TABLE IF NOT EXISTS app_users(
  id BIGSERIAL PRIMARY KEY,email TEXT UNIQUE NOT NULL,name TEXT NOT NULL,role TEXT NOT NULL,password_hash TEXT NOT NULL,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS workflow_cases(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,reference TEXT UNIQUE NOT NULL,subject TEXT NOT NULL,owner TEXT NOT NULL,state TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,payload JSONB NOT NULL DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS audit_events(
  id BIGSERIAL PRIMARY KEY,event_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),actor TEXT NOT NULL,action TEXT NOT NULL,object_type TEXT NOT NULL,object_reference TEXT NOT NULL,detail TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS saved_analyses(
  id BIGSERIAL PRIMARY KEY,workflow_id TEXT NOT NULL,actor TEXT NOT NULL,analysis_type TEXT NOT NULL,inputs JSONB NOT NULL,result JSONB NOT NULL,provider TEXT NOT NULL,model TEXT,created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS integration_state(
  id TEXT PRIMARY KEY,name TEXT NOT NULL,category TEXT NOT NULL,mode TEXT NOT NULL,status TEXT NOT NULL,last_tested TIMESTAMPTZ
);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_workflow ON workflow_cases(workflow_id);
CREATE INDEX IF NOT EXISTS idx_workflow_cases_due ON workflow_cases(due_date);
CREATE INDEX IF NOT EXISTS idx_audit_events_time ON audit_events(event_time DESC);

CREATE TABLE IF NOT EXISTS "op_qualification"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_qualification_due ON "op_qualification"(due_date);

CREATE TABLE IF NOT EXISTS "op_rent"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_rent_due ON "op_rent"(due_date);

CREATE TABLE IF NOT EXISTS "op_fraction"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_fraction_due ON "op_fraction"(due_date);

CREATE TABLE IF NOT EXISTS "op_recert"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_recert_due ON "op_recert"(due_date);

CREATE TABLE IF NOT EXISTS "op_vacancy"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_vacancy_due ON "op_vacancy"(due_date);

CREATE TABLE IF NOT EXISTS "op_student"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_student_due ON "op_student"(due_date);

CREATE TABLE IF NOT EXISTS "op_inspection"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_inspection_due ON "op_inspection"(due_date);

CREATE TABLE IF NOT EXISTS "op_recapture"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_caseReference" TEXT NOT NULL,
  "data_entity" TEXT NOT NULL,
  "data_reviewDate" DATE NOT NULL,
  "data_metric" NUMERIC(16,2) NOT NULL,
  "data_evidenceNotes" TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_recapture_due ON "op_recapture"(due_date);

CREATE TABLE IF NOT EXISTS "op_property_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_recordId" TEXT NOT NULL,
  "data_name" TEXT NOT NULL,
  "data_status" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_property_master_due ON "op_property_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_unit_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_recordId" TEXT NOT NULL,
  "data_name" TEXT NOT NULL,
  "data_status" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_unit_master_due ON "op_unit_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_limit_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_recordId" TEXT NOT NULL,
  "data_name" TEXT NOT NULL,
  "data_status" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_limit_master_due ON "op_limit_master"(due_date);

CREATE TABLE IF NOT EXISTS "op_household_master"(
  id BIGSERIAL PRIMARY KEY,reference TEXT UNIQUE NOT NULL,status TEXT NOT NULL,owner TEXT NOT NULL,risk TEXT NOT NULL,due_date DATE NOT NULL,amount NUMERIC(16,2) NOT NULL DEFAULT 0,
  "data_recordId" TEXT NOT NULL,
  "data_name" TEXT NOT NULL,
  "data_status" TEXT NOT NULL,
  "data_effectiveDate" DATE NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_op_household_master_due ON "op_household_master"(due_date);
