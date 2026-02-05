-- =============================================
-- WELLNESS SITE ADMIN PANEL - DATABASE SCHEMA
-- =============================================

-- Site Settings Table
CREATE TABLE site_settings (
  id SERIAL PRIMARY KEY,
  key VARCHAR(100) UNIQUE NOT NULL,
  value TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Pages Table
CREATE TABLE pages (
  id SERIAL PRIMARY KEY,
  slug VARCHAR(100) UNIQUE NOT NULL,
  title VARCHAR(255) NOT NULL,
  meta_title VARCHAR(255),
  meta_description TEXT,
  visible BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Navigation Table
CREATE TABLE navigation (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  url VARCHAR(255) NOT NULL,
  sort_order INTEGER DEFAULT 0,
  visible BOOLEAN DEFAULT TRUE,
  parent_id INTEGER REFERENCES navigation(id) ON DELETE SET NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =============================================
-- INSERT INITIAL DATA
-- =============================================

-- Site Settings
INSERT INTO site_settings (key, value) VALUES
  ('site_title', 'Wellness Bliss'),
  ('site_description', 'Experience the Healing Power of Massage'),
  ('phone', '1-800-123-1234'),
  ('email', 'info@wellnessbliss.com'),
  ('address', '123 Wellness Street, Spa City'),
  ('facebook', 'https://facebook.com/wellnessbliss'),
  ('instagram', 'https://instagram.com/wellnessbliss'),
  ('twitter', 'https://twitter.com/wellnessbliss'),
  ('hero_title', 'Experience the Healing Power of Massage'),
  ('hero_subtitle', 'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm');

-- Pages
INSERT INTO pages (slug, title, meta_title, meta_description, visible) VALUES
  ('index', 'Home', 'Home - Wellness Bliss', 'Experience the Healing Power of Massage at Wellness Bliss', true),
  ('services', 'Services', 'Our Services - Wellness Bliss', 'Discover our range of massage and wellness services', true),
  ('about-us', 'About Us', 'About Us - Wellness Bliss', 'Learn about our wellness center and our mission', true),
  ('our-team', 'Our Team', 'Our Team - Wellness Bliss', 'Meet our experienced massage therapists', true),
  ('prices-page', 'Prices', 'Prices - Wellness Bliss', 'View our service prices and packages', true),
  ('contacts', 'Contact', 'Contact Us - Wellness Bliss', 'Get in touch with us for appointments and inquiries', true),
  ('appointment', 'Appointment', 'Book an Appointment - Wellness Bliss', 'Schedule your massage appointment online', true),
  ('services-id', 'Service Details', 'Service Details - Wellness Bliss', 'Detailed information about our services', true);

-- Navigation
INSERT INTO navigation (title, url, sort_order, visible) VALUES
  ('Home', '/', 1, true),
  ('Services', '/services', 2, true),
  ('About Us', '/about-us', 3, true),
  ('Our Team', '/our-team', 4, true),
  ('Prices', '/prices-page', 5, true),
  ('Contact', '/contacts', 6, true),
  ('Appointment', '/appointment', 7, true);

-- =============================================
-- ROW LEVEL SECURITY (Optional - for public access)
-- =============================================

-- Enable RLS
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE navigation ENABLE ROW LEVEL SECURITY;

-- Allow public read/write (for demo - in production add auth)
CREATE POLICY "Allow all for site_settings" ON site_settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for pages" ON pages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for navigation" ON navigation FOR ALL USING (true) WITH CHECK (true);
