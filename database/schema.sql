-- Jobs table
CREATE TABLE IF NOT EXISTS jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(500) NOT NULL,
    company VARCHAR(200) NOT NULL,
    location VARCHAR(200),
    salary VARCHAR(100),
    description TEXT,
    requirements TEXT,
    job_url VARCHAR(1000) NOT NULL UNIQUE,
    company_url VARCHAR(1000),
    source VARCHAR(100) NOT NULL DEFAULT 'web_scraping',
    posted_date DATETIME,
    discovered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'discovered' CHECK (status IN ('discovered', 'analyzed', 'applying', 'applied', 'rejected', 'interview', 'offer', 'archived')),
    priority INTEGER DEFAULT 0 CHECK (priority >= 0 AND priority <= 100),
    match_score REAL CHECK (match_score >= 0 AND match_score <= 1),
    ai_analysis JSON,
    application_url VARCHAR(1000),
    contact_email VARCHAR(255),
    tags JSON,
    notes TEXT,
    last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Applications table
CREATE TABLE IF NOT EXISTS applications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    job_id INTEGER NOT NULL,
    cover_letter TEXT,
    resume_version VARCHAR(100),
    application_method VARCHAR(50) NOT NULL DEFAULT 'automated' CHECK (application_method IN ('automated', 'manual', 'email')),
    status VARCHAR(50) NOT NULL DEFAULT 'submitted' CHECK (status IN ('submitted', 'under_review', 'rejected', 'interview', 'offer', 'accepted', 'declined')),
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    response_received_at DATETIME,
    follow_up_count INTEGER DEFAULT 0,
    last_follow_up DATETIME,
    next_follow_up DATETIME,
    rejection_reason TEXT,
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
);

-- Interviews table
CREATE TABLE IF NOT EXISTS interviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    application_id INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'phone' CHECK (type IN ('phone', 'video', 'in_person', 'technical', 'final')),
    scheduled_at DATETIME NOT NULL,
    duration_minutes INTEGER DEFAULT 60,
    interviewer_name VARCHAR(200),
    interviewer_email VARCHAR(255),
    meeting_link VARCHAR(1000),
    location VARCHAR(500),
    status VARCHAR(50) NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled', 'rescheduled', 'no_show')),
    feedback TEXT,
    outcome VARCHAR(50) CHECK (outcome IN ('positive', 'negative', 'neutral', 'pending')),
    next_steps TEXT,
    preparation_notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE
);

-- Email accounts table
CREATE TABLE IF NOT EXISTS email_accounts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    provider VARCHAR(50) NOT NULL DEFAULT 'gmail',
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended', 'verification_pending')),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used DATETIME,
    applications_count INTEGER DEFAULT 0,
    verification_status VARCHAR(50) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'failed')),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at DATETIME
);

-- Email conversations table
CREATE TABLE IF NOT EXISTS email_conversations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    application_id INTEGER NOT NULL,
    email_account_id INTEGER NOT NULL,
    thread_id VARCHAR(255),
    subject VARCHAR(500),
    from_email VARCHAR(255),
    to_email VARCHAR(255),
    message_type VARCHAR(50) NOT NULL CHECK (message_type IN ('application', 'follow_up', 'interview_invite', 'rejection', 'offer', 'other')),
    content TEXT,
    is_outbound BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at DATETIME,
    received_at DATETIME,
    read_status BOOLEAN DEFAULT FALSE,
    responded BOOLEAN DEFAULT FALSE,
    auto_response BOOLEAN DEFAULT FALSE,
    attachments JSON,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE,
    FOREIGN KEY (email_account_id) REFERENCES email_accounts(id) ON DELETE CASCADE
);

-- System logs table
CREATE TABLE IF NOT EXISTS system_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    level VARCHAR(20) NOT NULL CHECK (level IN ('DEBUG', 'INFO', 'WARN', 'ERROR')),
    message TEXT NOT NULL,
    component VARCHAR(100),
    job_id INTEGER,
    application_id INTEGER,
    error_details JSON,
    stack_trace TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE SET NULL,
    FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE SET NULL
);

-- Search history table
CREATE TABLE IF NOT EXISTS search_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    keywords VARCHAR(500),
    location VARCHAR(200),
    job_boards JSON,
    results_count INTEGER DEFAULT 0,
    new_jobs_count INTEGER DEFAULT 0,
    search_duration_seconds INTEGER,
    status VARCHAR(50) NOT NULL DEFAULT 'completed' CHECK (status IN ('running', 'completed', 'failed', 'cancelled')),
    error_message TEXT,
    started_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME
);

-- User settings table
CREATE TABLE IF NOT EXISTS user_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value JSON NOT NULL,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_jobs_status ON jobs(status);
CREATE INDEX IF NOT EXISTS idx_jobs_company ON jobs(company);
CREATE INDEX IF NOT EXISTS idx_jobs_discovered_at ON jobs(discovered_at);
CREATE INDEX IF NOT EXISTS idx_jobs_priority ON jobs(priority);
CREATE INDEX IF NOT EXISTS idx_jobs_match_score ON jobs(match_score);

CREATE INDEX IF NOT EXISTS idx_applications_job_id ON applications(job_id);
CREATE INDEX IF NOT EXISTS idx_applications_status ON applications(status);
CREATE INDEX IF NOT EXISTS idx_applications_submitted_at ON applications(submitted_at);

CREATE INDEX IF NOT EXISTS idx_interviews_application_id ON interviews(application_id);
CREATE INDEX IF NOT EXISTS idx_interviews_scheduled_at ON interviews(scheduled_at);
CREATE INDEX IF NOT EXISTS idx_interviews_status ON interviews(status);

CREATE INDEX IF NOT EXISTS idx_email_conversations_application_id ON email_conversations(application_id);
CREATE INDEX IF NOT EXISTS idx_email_conversations_thread_id ON email_conversations(thread_id);
CREATE INDEX IF NOT EXISTS idx_email_conversations_sent_at ON email_conversations(sent_at);

CREATE INDEX IF NOT EXISTS idx_system_logs_level ON system_logs(level);
CREATE INDEX IF NOT EXISTS idx_system_logs_component ON system_logs(component);
CREATE INDEX IF NOT EXISTS idx_system_logs_created_at ON system_logs(created_at);

-- Insert default settings
INSERT OR IGNORE INTO user_settings (setting_key, setting_value, description) VALUES
('search_keywords', '["software developer", "full stack developer", "javascript developer"]', 'Default search keywords'),
('search_location', '"Remote"', 'Default search location'),
('max_applications_per_day', '10', 'Maximum number of applications to send per day'),
('auto_apply_enabled', 'true', 'Whether to automatically apply to jobs'),
('min_match_score', '0.7', 'Minimum match score required for auto-application'),
('follow_up_delay_days', '7', 'Number of days to wait before sending follow-up emails'),
('email_check_interval', '30', 'Interval in minutes to check for new emails'),
('job_search_interval', '6', 'Interval in hours to run job searches');