-- =============================================
-- WELLNESS SITE - FULL DATABASE SCHEMA
-- =============================================

-- 1. CLEANUP
DROP TABLE IF EXISTS page_sections;
DROP TABLE IF EXISTS navigation;
DROP TABLE IF EXISTS pages;
DROP TABLE IF EXISTS site_settings;

-- 2. TABLE DEFINITIONS

-- Site Settings
CREATE TABLE site_settings (
    id SERIAL PRIMARY KEY,
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Pages
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

-- Navigation
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

-- Page Sections
CREATE TABLE page_sections (
    id SERIAL PRIMARY KEY,
    page_slug VARCHAR(100) NOT NULL, -- FK to pages(slug) logic but kept loose for flexibility
    section_key VARCHAR(100) NOT NULL,
    section_type VARCHAR(50) NOT NULL,
    title TEXT,
    subtitle TEXT,
    description TEXT,
    button_text VARCHAR(100),
    button_url VARCHAR(255),
    image_url TEXT,
    extra_data JSONB DEFAULT '{}'::jsonb,
    sort_order INTEGER DEFAULT 0,
    visible BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(page_slug, section_key)
);

-- 3. INITIAL DATA INSERTION

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

-- Page Sections: Global
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('_global', 'popup', 'popup',
     'Discover Deep Relaxation at Our Massage Sanctuary',
     'SPECIAL OFFER!',
     'Take 20% off your first massage session when you book within the next 24 hours. Let stress melt away. You deserve this.',
     'Book Now', '/contacts', 1);

-- Page Sections: Home (index)
-- Page Sections: Home (index)
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('index', 'hero', 'hero', 
     'Experience the Healing Power of Massage', NULL, NULL,
     'Explore Our Services', '/services', NULL, '{}'::jsonb, 1, true),
    ('index', 'intro', 'intro',
     'Welcome to Wellness Bliss', NULL, 
     'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm. Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out.',
     NULL, NULL, NULL, '{}'::jsonb, 2, true),
    ('index', 'about', 'about',
     'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm',
     'Welcome to Wellness Bliss',
     'Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out. At Wellness Bliss, we believe true healing begins with presence and touch.',
     'More About Us', '/about-us', NULL, '{}'::jsonb, 3, true),
    ('index', 'services', 'services',
     'Our Services', NULL, NULL,
     'View all Services', '/services-page', NULL, '{}'::jsonb, 3, true), -- Note: services was 4 in original, but 3 in update. Let's make it 4 to keep about at 3. Actually I will use 4 for Services.
    ('index', 'features', 'features',
     'The Healing Power of Touch',
     'Restore Balance, Ease Tension, and Reconnect with Your Body',
     NULL, NULL, NULL, NULL,
     '{"features": [
        {"title": "Relieves Stress & Anxiety", "description": "Massage promotes deep relaxation, calming the nervous system and reducing mental fatigue."},
        {"title": "Eases Muscle Tension & Pain", "description": "Targeted techniques release knots, improve flexibility, and help with chronic pain."},
        {"title": "Boosts Immunity", "description": "Enhances blood circulation, supporting natural detoxification, rejuvenation and overall vitality."},
        {"title": "Improves Sleep & Mood", "description": "Encourages better sleep patterns and elevates mood through the release of feel-good hormones."}
    ]}'::jsonb, 5, true),
    ('index', 'team', 'team',
     'Experience the Healing Power of Massage', 
     'Professional, certified therapists with a passion for holistic healing.',
     NULL,
     'Choose a Specialist', '/our-team', NULL, '{}'::jsonb, 6, true),
    ('index', 'gallery', 'gallery',
     'Photo Gallery',
     'A visual journey of mind and body harmony',
     NULL, NULL, NULL, NULL, '{}'::jsonb, 7, true),
    ('index', 'pricing', 'pricing',
     'Pricing plans for your wellness journey', NULL, 
     'We offer simple, flat rate pricing for all our services. All initial consultations include treatment unless further testing is required.',
     'Full Price List', '/prices-page', NULL, '{}'::jsonb, 8, true),
    ('index', 'testimonials', 'testimonials',
     'What our clients say about us',
     'More than 250 five-star reviews on Google',
     NULL, NULL, NULL, NULL, '{}'::jsonb, 9, true),
    ('index', 'blog', 'blog',
     'Wellness Blog', NULL, NULL,
     'More Blog Posts', '/blog-page', NULL, '{}'::jsonb, 10, true),
    ('index', 'cta', 'cta',
     'What''s Your Next Step?', NULL, 
     'Make a step to start your journey to holistic healing with Wellness Bliss.',
     NULL, NULL, '/assets/light/wp-content/uploads/sites/4/2025/04/icon-5.svg', '{}'::jsonb, 11, true),
    ('index', 'instagram_gallery', 'gallery',
     NULL, NULL, NULL, NULL, NULL, NULL, '{}'::jsonb, 12, true);

-- Page Sections: About Us
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('about-us', 'hero', 'hero',
     'Why We are the Best Spa Center?', 'ABOUT US',
     'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
     NULL, NULL, 1),
    ('about-us', 'content', 'content',
     'Warmth, Professionalism, Expert Therapists', NULL,
     'We use premium products and our expert therapists are dedicated to your wellness journey.',
     NULL, NULL, 2),
    ('about-us', 'team', 'team',
     'Meet Our Team', NULL,
     'Meet our expert team of therapists.',
     NULL, NULL, 3);

-- Page Sections: Services
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('services', 'hero', 'hero',
     'Services Page', NULL,
     'World-class rehabilitation solutions and individualized recovery plans, from acute care to ongoing outpatient treatment and beyond.',
     NULL, NULL, 1),
    ('services', 'packages', 'services',
     'Wellness Packages', NULL,
     'Serenity Starter, Balance & Recenter, Deep Restoration',
     NULL, NULL, 2),
    ('services', 'services_list', 'services',
     'Our Treatments', NULL,
     'Swedish Relaxation Massage, Facial Massage, Aromatherapy Massage',
     NULL, NULL, 3);

-- Page Sections: Contacts
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('contacts', 'hero', 'hero',
     'Contact Us Easily Online, by Phone or by Dropping In', 'CONTACT US',
     NULL, NULL, NULL, 1),
    ('contacts', 'info', 'contact',
     'Contact Information', NULL,
     'Phone: + 0800 2336 7811 | Address: 14960 Florence Trail Apple Valley, MN 55124 | Hours: Monday – Sunday, 9am – 7pm EST',
     NULL, NULL, 2);

-- Page Sections: Our Team
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('our-team', 'hero', 'hero',
     'Our Team', NULL,
     'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
     NULL, NULL, 1),
    ('our-team', 'team_list', 'team',
     'Our Specialists', NULL,
     'Angela Carbone, Mason Goodman, Whitney Pratt, Anne Middleton, Mark Hoffman, Martha Ruiz',
     NULL, NULL, 2);

-- Page Sections: Prices Page
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('prices-page', 'hero', 'hero',
     'Prices Page', NULL,
     'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
     NULL, NULL, 1),
    ('prices-page', 'pricing_table', 'pricing',
     'Our Pricing', NULL,
     'Detailed pricing tables for various wellness and massage packages.',
     NULL, NULL, 2);


-- 4. ROW LEVEL SECURITY
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE navigation ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_sections ENABLE ROW LEVEL SECURITY;

-- Allow public read/write (for demo/development)
CREATE POLICY "Allow all for site_settings" ON site_settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for pages" ON pages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for navigation" ON navigation FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for page_sections" ON page_sections FOR ALL USING (true) WITH CHECK (true);

