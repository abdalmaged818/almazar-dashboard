-- ============================================================
-- Al Mazar Marketing Operating System
-- Supabase Database Schema
-- Run this in your Supabase SQL Editor
-- ============================================================

-- TABLE: reports
-- Stores weekly reports built by admin team
CREATE TABLE IF NOT EXISTS reports (
  id            UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  report_data   JSONB NOT NULL DEFAULT '{}',
  dashboard_data JSONB NOT NULL DEFAULT '{}',
  month         INTEGER NOT NULL CHECK (month BETWEEN 1 AND 12),
  week_number   INTEGER NOT NULL CHECK (week_number BETWEEN 1 AND 5),
  status        TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','published','archived')),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- INDEX for fast client queries
CREATE INDEX IF NOT EXISTS idx_reports_month_week
  ON reports (month, week_number, status);

CREATE INDEX IF NOT EXISTS idx_reports_status_created
  ON reports (status, created_at DESC);

-- TABLE: tasks
-- Daily task management for admin team
CREATE TABLE IF NOT EXISTS tasks (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title       TEXT NOT NULL,
  description TEXT DEFAULT '',
  type        TEXT NOT NULL DEFAULT 'other'
              CHECK (type IN ('content','engagement','campaign','gmaps','delivery','sales','other')),
  priority    TEXT NOT NULL DEFAULT 'medium'
              CHECK (priority IN ('high','medium','low')),
  status      TEXT NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending','inprogress','done')),
  date        DATE DEFAULT CURRENT_DATE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tasks_status_date
  ON tasks (status, date DESC);

-- TABLE: daily_activity
-- Daily activity tracking logs
CREATE TABLE IF NOT EXISTS daily_activity (
  id                UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date              DATE NOT NULL UNIQUE,
  posts             INTEGER DEFAULT 0,
  stories           INTEGER DEFAULT 0,
  videos            INTEGER DEFAULT 0,
  reels             INTEGER DEFAULT 0,
  comments          INTEGER DEFAULT 0,
  messages          INTEGER DEFAULT 0,
  conversations     INTEGER DEFAULT 0,
  influencers       INTEGER DEFAULT 0,
  influencer_visits INTEGER DEFAULT 0,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_daily_activity_date
  ON daily_activity (date DESC);

-- TABLE: clients (Future extension)
-- Multi-client support
CREATE TABLE IF NOT EXISTS clients (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name       TEXT NOT NULL,
  slug       TEXT UNIQUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- Enable when you add authentication
-- ============================================================

-- ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE daily_activity ENABLE ROW LEVEL SECURITY;

-- PUBLIC READ: only published reports visible to clients
-- CREATE POLICY "Published reports are public"
--   ON reports FOR SELECT
--   USING (status = 'published');

-- ============================================================
-- SAMPLE DATA (Optional — remove before production)
-- ============================================================
-- INSERT INTO reports (report_data, dashboard_data, month, week_number, status)
-- VALUES (
--   '{"salesTotal":15000,"salesPrev":13000,"orders":280,"avgOrder":54,"salesTarget":16000,"achievements":"زيادة مبيعات ريلز 45%","notes":"الموسم القادم جيد","nextPlan":"حملة رمضان - 3 ريلز يومياً"}',
--   '{"salesTotal":15000,"salesGrowth":15,"orders":280,"avgOrder":54,"targetAchievement":94,"totalViews":45000,"totalEngagement":2800,"igReach":18000,"ttViews":27000}',
--   4, 2, 'published'
-- );
