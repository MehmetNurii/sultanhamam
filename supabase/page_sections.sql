-- Page Sections - TÜM SAYFALARIN GERÇEK İÇERİKLERİ
-- Supabase SQL Editor'da çalıştır

-- Mevcut verileri temizle
DELETE FROM page_sections;

-- =============================================
-- GLOBAL BÖLÜMLER (Popup - Tüm Sayfalarda Ortak)
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
('_global', 'popup', 'popup',
 'Discover Deep Relaxation at Our Massage Sanctuary',
 'SPECIAL OFFER!',
 'Take 20% off your first massage session when you book within the next 24 hours. Let stress melt away. You deserve this.',
 'Book Now',
 '/contacts',
 1);

-- =============================================
-- ANA SAYFA (index)
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

-- HERO
('index', 'hero', 'hero', 
 'Experience the Healing Power of Massage', 
 NULL,
 NULL,
 'Explore Our Services',
 '/services',
 1),

-- BOOK FORM
('index', 'hero_form', 'form',
 'Book a Visit',
 NULL,
 NULL,
 NULL,
 NULL,
 2),

-- HAKKIMIZDA
('index', 'about', 'about',
 'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm',
 'Welcome to Wellness Bliss',
 'Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out. At Wellness Bliss, we believe true healing begins with presence and touch.',
 'More About Us',
 '/about-us',
 3),

-- HİZMETLER
('index', 'services', 'services',
 'Our Services',
 NULL,
 NULL,
 'View all Services',
 '/services',
 4),

-- FAYDALAR
('index', 'benefits', 'benefits',
 'Restore Balance, Ease Tension, and Reconnect with Your Body',
 NULL,
 'Relieves Stress & Anxiety, Eases Muscle Tension & Pain, Boosts Immunity, Improves Sleep & Mood',
 NULL,
 NULL,
 5),

-- EKİP
('index', 'team', 'team',
 'Our Massage Therapists',
 '13 Years of quality service',
 NULL,
 NULL,
 '/our-team',
 6),

-- FİYATLANDIRMA
('index', 'pricing', 'pricing',
 'Pricing plans for your wellness journey',
 NULL,
 NULL,
 NULL,
 '/prices-page',
 7),

-- SON CTA
('index', 'cta', 'cta',
 'What''s Your Next Step?',
 NULL,
 NULL,
 NULL,
 NULL,
 8);

-- =============================================
-- ABOUT US SAYFASI
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

('about-us', 'hero', 'hero',
 'Why We are the Best Spa Center?',
 'ABOUT US',
 'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
 NULL,
 NULL,
 1),

('about-us', 'content', 'content',
 'Warmth, Professionalism, Expert Therapists',
 NULL,
 'We use premium products and our expert therapists are dedicated to your wellness journey.',
 NULL,
 NULL,
 2),

('about-us', 'team', 'team',
 'Meet Our Team',
 NULL,
 'Angela Carbone (Soft Tissue), Mason Goodman (Reflexology), Whitney Pratt (Massage)',
 NULL,
 NULL,
 3);

-- =============================================
-- SERVICES SAYFASI
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

('services', 'hero', 'hero',
 'Services Page',
 NULL,
 'World-class rehabilitation solutions and individualized recovery plans, from acute care to ongoing outpatient treatment and beyond.',
 NULL,
 NULL,
 1),

('services', 'packages', 'services',
 'Wellness Packages',
 NULL,
 'Serenity Starter, Balance & Recenter, Deep Restoration',
 NULL,
 NULL,
 2),

('services', 'services_list', 'services',
 'Our Treatments',
 NULL,
 'Swedish Relaxation Massage, Facial Massage, Aromatherapy Massage',
 NULL,
 NULL,
 3);

-- =============================================
-- CONTACTS SAYFASI
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

('contacts', 'hero', 'hero',
 'Contact Us Easily Online, by Phone or by Dropping In',
 'CONTACT US',
 NULL,
 NULL,
 NULL,
 1),

('contacts', 'info', 'contact',
 'Contact Information',
 NULL,
 'Phone: + 0800 2336 7811 | Address: 14960 Florence Trail Apple Valley, MN 55124 | Hours: Monday – Sunday, 9am – 7pm EST',
 NULL,
 NULL,
 2);

-- =============================================
-- OUR TEAM SAYFASI
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

('our-team', 'hero', 'hero',
 'Our Team',
 NULL,
 'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
 NULL,
 NULL,
 1),

('our-team', 'team_list', 'team',
 'Our Specialists',
 NULL,
 'Angela Carbone, Mason Goodman, Whitney Pratt, Anne Middleton, Mark Hoffman, Martha Ruiz',
 NULL,
 NULL,
 2);

-- =============================================
-- PRICES PAGE SAYFASI
-- =============================================
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES

('prices-page', 'hero', 'hero',
 'Prices Page',
 NULL,
 'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
 NULL,
 NULL,
 1),

('prices-page', 'pricing_table', 'pricing',
 'Our Pricing',
 NULL,
 'Detailed pricing tables for various wellness and massage packages.',
 NULL,
 NULL,
 2);

-- Verileri doğrula
SELECT page_slug, section_key, section_type, title FROM page_sections ORDER BY page_slug, sort_order;
