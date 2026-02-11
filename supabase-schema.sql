-- =============================================
-- WELLNESS SITE - FULL DATABASE SCHEMA
-- =============================================

-- 1. CLEANUP
DROP TABLE IF EXISTS service_faqs;
DROP TABLE IF EXISTS services;
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
    url VARCHAR(255) DEFAULT '#',
    sort_order INTEGER DEFAULT 0,
    visible BOOLEAN DEFAULT TRUE,
    parent_id INTEGER REFERENCES navigation(id) ON DELETE CASCADE,
    location VARCHAR(50) DEFAULT 'header',
    extra_data JSONB DEFAULT '{}'::jsonb,
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

-- Services
CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(100) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    short_description TEXT,
    full_description TEXT,
    hero_image_url TEXT,
    icon_url TEXT,
    sidebar_links JSONB DEFAULT '[]'::jsonb,
    visible BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service FAQs
CREATE TABLE service_faqs (
    id SERIAL PRIMARY KEY,
    service_id INTEGER NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
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
    ('hero_subtitle', 'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm'),
    ('footer_discount_text', 'Get a special 50% new client discount and unleash your health.'),
    ('footer_newsletter_title', 'Sign up to Newsletter'),
    ('footer_newsletter_button', 'Sign Up'),
    ('site_url', 'https://wellness-bliss.cmsmasters.studio/light'),
    ('home_two_url', 'https://wellness-bliss.cmsmasters.studio/light/home-two/'),
    ('logo_url', '/assets/light/wp-content/uploads/sites/4/2025/05/logo-2.svg'),
    ('logo_alt', 'Light Demo'),
    ('logo_title', 'Light Demo'),
    ('work_hours_weekday', 'Monday to Friday: 9AM - 6PM'),
    ('work_hours_saturday', 'Saturday: 9AM - 6PM'),
    ('work_hours_sunday', 'Sunday: 9AM - 5PM'),
    ('copyright_text', '© 2026 - All Rights Reserved'),
    ('sample_site_text', 'This is a sample website'),
    ('contacts_url', '/contacts'),
    ('book_appointment_text', 'Book an Appointment'),
    ('book_appointment_description', 'Your life is waiting. Fast, long-lasting relief is nearby.'),
    ('book_visit_text', 'Book a Visit'),
    ('book_online_text', 'Book Online'),
    ('view_directions_text', 'View Directions'),
    ('view_directions_url', '/contacts'),
    ('address_label', 'Address'),
    ('work_hours_label', 'Work Hours'),
    ('contacts_label', 'Contacts'),
    ('header_navigation', '[{"title":"Home","url":"#","visible":true,"menu_type":"mega_menu","children":[{"title":"Home One - Wellness Center","url":"/","visible":true,"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-1-light.webp"},{"title":"Home Two - Massage Salon","url":"/home-two/","visible":true,"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-2-light.webp"},{"title":"Home Three - Spa Resort","url":"/home-three/","visible":true,"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-3-light.webp"}]},{"title":"About Us","url":"/about-us","visible":true,"children":[]},{"title":"Services","url":"#","visible":true,"children":[{"title":"All Services","url":"/services-page","visible":true,"children":[]},{"title":"Wellness Packages","url":"#","visible":true,"children":[{"title":"Balance & Recenter","url":"/services/balance-recenter/","visible":true},{"title":"Blissful Renewal Day","url":"/services/blissful-renewal-day/","visible":true},{"title":"Deep Restoration","url":"/services/deep-restoration/","visible":true},{"title":"Inner Glow Detox","url":"/services/inner-glow-detox/","visible":true},{"title":"Moon & Soul Ritual","url":"/services/moon-soul-ritual/","visible":true},{"title":"Serenity Starter","url":"/services/serenity-starter/","visible":true}]},{"title":"Reflexology Therapy","url":"/services/reflexology-therapy/","visible":true,"children":[]},{"title":"Facial Massage","url":"/services/facial-massage/","visible":true,"children":[]},{"title":"Swedish Relaxation Massage","url":"/services/swedish-relaxation-massage/","visible":true,"children":[]},{"title":"Deep Tissue Therapy","url":"/services/deep-tissue-therapy/","visible":true,"children":[]},{"title":"Hot Stone Massage","url":"/services/hot-stone-massage/","visible":true,"children":[]},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/","visible":true,"children":[]}]},{"title":"Pages","url":"#","visible":true,"children":[{"title":"Appointment","url":"/appointment","visible":true,"children":[]},{"title":"Our Team","url":"/our-team","visible":true,"children":[]},{"title":"Prices Guide","url":"/prices-page","visible":true,"children":[]},{"title":"Shop","url":"/shop","visible":true,"children":[]},{"title":"Events","url":"/events-page","visible":true,"children":[]},{"title":"Blog","url":"/blog-page","visible":true,"children":[]},{"title":"Image Credits","url":"/image-credits","visible":true,"children":[]}]},{"title":"Contacts","url":"/contacts","visible":true,"children":[]}]'),
    ('footer_navigation', '[{"title":"Home","url":"/","visible":true},{"title":"About Us","url":"/about-us","visible":true},{"title":"Shop","url":"/shop","visible":true},{"title":"Blog","url":"/blog-page","visible":true},{"title":"Contacts","url":"/contacts","visible":true}]')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

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

-- Navigation: Header + Footer hierarchical menu
INSERT INTO navigation (id, title, url, sort_order, visible, parent_id, location, extra_data) VALUES
    -- HEADER TOP-LEVEL
    (1, 'Home', '#', 1, true, NULL, 'header', '{"menu_type":"mega_menu"}'),
    (2, 'About Us', '/about-us', 2, true, NULL, 'header', '{}'),
    (3, 'Services', '#', 3, true, NULL, 'header', '{}'),
    (4, 'Pages', '#', 4, true, NULL, 'header', '{}'),
    (5, 'Contacts', '/contacts', 5, true, NULL, 'header', '{}'),
    -- Home mega menu children
    (6, 'Home One - Wellness Center', '/', 1, true, 1, 'header', '{"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-1-light.webp"}'),
    (7, 'Home Two - Massage Salon', '/home-two/', 2, true, 1, 'header', '{"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-2-light.webp"}'),
    (8, 'Home Three - Spa Resort', '/home-three/', 3, true, 1, 'header', '{"image_url":"/assets/light/wp-content/uploads/sites/4/2025/05/61-mega-menu-3-light.webp"}'),
    -- Services sub-menu
    (9, 'All Services', '/services-page', 1, true, 3, 'header', '{}'),
    (10, 'Wellness Packages', '#', 2, true, 3, 'header', '{}'),
    (11, 'Reflexology Therapy', '/services/reflexology-therapy/', 3, true, 3, 'header', '{}'),
    (12, 'Facial Massage', '/services/facial-massage/', 4, true, 3, 'header', '{}'),
    (13, 'Swedish Relaxation Massage', '/services/swedish-relaxation-massage/', 5, true, 3, 'header', '{}'),
    (14, 'Deep Tissue Therapy', '/services/deep-tissue-therapy/', 6, true, 3, 'header', '{}'),
    (15, 'Hot Stone Massage', '/services/hot-stone-massage/', 7, true, 3, 'header', '{}'),
    (16, 'Aromatherapy Massage', '/services/aromatherapy-massage/', 8, true, 3, 'header', '{}'),
    -- Wellness Packages sub-sub-menu
    (17, 'Balance & Recenter', '/services/balance-recenter/', 1, true, 10, 'header', '{}'),
    (18, 'Blissful Renewal Day', '/services/blissful-renewal-day/', 2, true, 10, 'header', '{}'),
    (19, 'Deep Restoration', '/services/deep-restoration/', 3, true, 10, 'header', '{}'),
    (20, 'Inner Glow Detox', '/services/inner-glow-detox/', 4, true, 10, 'header', '{}'),
    (21, 'Moon & Soul Ritual', '/services/moon-soul-ritual/', 5, true, 10, 'header', '{}'),
    (22, 'Serenity Starter', '/services/serenity-starter/', 6, true, 10, 'header', '{}'),
    -- Pages sub-menu
    (23, 'Appointment', '/appointment', 1, true, 4, 'header', '{}'),
    (24, 'Our Team', '/our-team', 2, true, 4, 'header', '{}'),
    (25, 'Prices Guide', '/prices-page', 3, true, 4, 'header', '{}'),
    (26, 'Shop', '/shop', 4, true, 4, 'header', '{}'),
    (27, 'Events', '/events-page', 5, true, 4, 'header', '{}'),
    (28, 'Blog', '/blog-page', 6, true, 4, 'header', '{}'),
    (29, 'Image Credits', '/image-credits', 7, true, 4, 'header', '{}'),
    -- FOOTER navigation
    (30, 'Home', '/', 1, true, NULL, 'footer', '{}'),
    (31, 'About Us', '/about-us', 2, true, NULL, 'footer', '{}'),
    (32, 'Shop', '/shop', 3, true, NULL, 'footer', '{}'),
    (33, 'Blog', '/blog-page', 4, true, NULL, 'footer', '{}'),
    (34, 'Contacts', '/contacts', 5, true, NULL, 'footer', '{}');

SELECT setval('navigation_id_seq', 34);
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
     'Explore Our Services', '/services-page', NULL, '{}'::jsonb, 1, true),
    ('index', 'intro', 'intro',
     'Welcome to Wellness Bliss',
     'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm',
     'Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out.',
     NULL, NULL, NULL, '{}'::jsonb, 2, true),
    ('index', 'about', 'about',
     NULL, NULL,
     'At Wellness Bliss, we believe true healing begins with presence and touch. Each session is a one-on-one experience with a skilled therapist who takes the time to understand your body''s needs, helping you achieve real, lasting results.',
     'More About Us', '/about-us', '/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-3.webp', '{}'::jsonb, 3, true),
    ('index', 'services', 'services',
     'Our Services', NULL, NULL,
     'View all Services', '/services-page', NULL,
     '{"services": [
        {
          "title": "Swedish Relaxation Massage",
          "description": "Using gentle to medium pressure and flowing strokes, this massage promotes deep relaxation, improves circulation, and soothes tired muscles.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp",
          "button_text": "Read More",
          "url": "/services/swedish-relaxation-massage/"
        },
        {
          "title": "Facial Massage",
          "description": "Our facial massage uses light, soothing strokes to boost circulation, release tension, and enhance your skin\u2019s natural glow.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp",
          "button_text": "Read More",
          "url": "/services/facial-massage/"
        },
        {
          "title": "Aromatherapy Massage",
          "description": "This massage combines gentle, flowing techniques with the healing power of essential oils chosen specifically for your needs \u2014 whether calming, energizing, or balancing.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp",
          "button_text": "Read More",
          "url": "/services/aromatherapy-massage/"
        },
        {
          "title": "Hot Stone Massage",
          "description": "Smooth, heated stones are placed on key points of the body and used in flowing massage strokes to ease muscle tension and enhance circulation.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp",
          "button_text": "Read More",
          "url": "/services/hot-stone-massage/"
        },
        {
          "title": "Deep Tissue Therapy",
          "description": "This intensive massage technique targets deeper layers of muscle and connective tissue to relieve chronic pain, stiffness, and tension.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp",
          "button_text": "Read More",
          "url": "/services/deep-tissue-therapy/"
        },
        {
          "title": "Reflexology Therapy",
          "description": "This specialized treatment focuses on pressure points in the feet, hands, and ears that correspond to different organs and systems of the body.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp",
          "button_text": "Read More",
          "url": "/services/reflexology-therapy/"
        }
     ]}'::jsonb, 4, true),
    ('index', 'features', 'features',
     'The Healing Power of Touch',
     'Restore Balance, Ease Tension, and Reconnect with Your Body',
     NULL, 'Find out More', '/services-page', NULL,
     '{"features": [
        {"title": "Relieves Stress & Anxiety", "description": "Massage promotes deep relaxation, calming the nervous system and reducing mental fatigue."},
        {"title": "Eases Muscle Tension & Pain", "description": "Targeted techniques release knots, improve flexibility, and help with chronic pain."},
        {"title": "Boosts Immunity", "description": "Enhances blood circulation, supporting natural detoxification, rejuvenation and overall vitality."},
        {"title": "Improves Sleep & Mood", "description": "Encourages better sleep patterns and elevates mood through the release of feel-good hormones."}
     ],
     "counter_number": "13",
     "counter_text": "Years of quality service"
    }'::jsonb, 5, true),
    ('index', 'team', 'team',
     'Experience the Healing Power of Massage', 
     'Professional, certified therapists with a passion for holistic healing.',
     NULL,
     'Choose a Specialist', '/our-team', NULL,
     '{"team_members": [
        {
          "name": "Angela Carbone",
          "role": "Soft Tissue Therapist",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-1.webp",
          "profile_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/angela-carbone/",
          "role_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/soft-tissue-therapist/",
          "social_links": {
            "facebook": "/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio",
            "twitter": "/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html",
            "linkedin": "https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"
          }
        },
        {
          "name": "Mason Goodman",
          "role": "Reflexology Therapist",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-2.webp",
          "profile_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/mason-goodman/",
          "role_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/reflexology-therapist/",
          "social_links": {
            "facebook": "/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio",
            "twitter": "/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html",
            "linkedin": "https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"
          }
        },
        {
          "name": "Whitney Pratt",
          "role": "Massage Therapist",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-3.webp",
          "profile_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/samuel-carter/",
          "role_url": "https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/massage-therapist/",
          "social_links": {
            "facebook": "/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio",
            "twitter": "/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html",
            "linkedin": "https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"
          }
        }
     ]}'::jsonb, 6, true),
    ('index', 'gallery', 'gallery',
     'Photo Gallery',
     'A visual journey of mind and body harmony',
     NULL, NULL, NULL, NULL, 
     '{"gallery_images": [
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-5.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-6.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-7.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-8.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-9.webp"
     ]}'::jsonb, 7, true),
    ('index', 'pricing', 'pricing',
     'Pricing plans for your wellness journey', NULL, 
     'We offer simple, flat rate pricing for all our services. All initial consultations include treatment unless further testing is required.',
     'Full Price List', '/prices-page', NULL,
     '{"pricing_categories": [
        {
          "title": "Massage Therapy",
          "description": "Stimulate the body''s own healing response.",
          "icon_class": "cmsms-demo-icons-wellness-bliss",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "items": [
            {"name": "Relaxation Massage - 60 mins", "price": "$70"},
            {"name": "Relaxation Massage - 90 mins", "price": "$95"},
            {"name": "Deep Tissue Massage - 60 mins", "price": "$75"},
            {"name": "Deep Tissue Massage - 90 mins", "price": "$100"},
            {"name": "Hot Stone Massage - 60 mins", "price": "$80"},
            {"name": "Hot Stone Massage - 90 mins", "price": "$115"}
          ]
        },
        {
          "title": "Reflexology Therapy",
          "description": "Relieve pain and limitation of movement.",
          "icon_class": "cmsms-demo-icons-wellness-15",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$50"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$45"},
                {"name": "60 mins", "price": "$60"}
              ]
            }
          ]
        },
        {
          "title": "Acupuncture Session",
          "description": "Stimulate the body''s own healing response.",
          "icon_class": "cmsms-demo-icons-wellness-11",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "groups": [
            {
              "group_title": "Initial Consultation",
              "items": [{"name": "45 mins", "price": "$50"}]
            },
            {
              "group_title": "Follow Up Treatment",
              "items": [
                {"name": "30 mins", "price": "$45"},
                {"name": "60 mins", "price": "$60"}
              ]
            }
          ]
        }
     ]}'::jsonb, 8, true),
    ('index', 'testimonials', 'testimonials',
     'What our clients say about us',
     'More than 250 five-star reviews on Google',
     NULL, NULL, NULL, NULL, 
     '{"testimonials": [
        {
          "name": "Sarah L.",
          "text": "I came in carrying weeks of stress, tension, and sleepless nights. One session here changed everything. The therapist worked through the tightness in my back and shoulders with such skill and care. I left feeling grounded, peaceful, and for the first time in a long while—pain-free. This place is truly healing.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-1.webp",
          "rating": 5
        },
        {
          "name": "James T.",
          "text": "I came in carrying weeks of stress, tension, and sleepless nights. One session here changed everything. The therapist worked through the tightness in my back and shoulders with such skill and care. I left feeling grounded, peaceful, and for the first time in a long while—pain-free. This place is truly healing.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-2.webp",
          "rating": 5
        },
        {
          "name": "Alina M.",
          "text": "It''s not just a massage—it''s a full-body reset. The energy, the warmth, the atmosphere... everything is designed to make you feel safe and at ease. Every visit feels like a mini retreat from the world. I always leave with a calm mind and a body that feels brand new.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-3.webp",
          "rating": 5
        },
        {
          "name": "Daniel K.",
          "text": "Incredible experience from start to finish. The therapist had an intuitive touch and created a space that felt calm and restorative. My chronic neck and shoulder pain has improved so much, and the effects last long after the session. I feel genuinely cared for every time I visit.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-4.webp",
          "rating": 5
        },
        {
          "name": "Emma R.",
          "text": "The best massage I''ve ever had. The attention to detail, the personalized approach, and the genuine care shown by the staff make this place special. I''ve been coming regularly for months, and each session is better than the last.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-5.webp",
          "rating": 5
        }
     ]}'::jsonb, 9, true),
    ('index', 'blog', 'blog',
     'Wellness Blog', NULL, NULL,
     'More Blog Posts', '/blog-page', NULL,
     '{"blog_posts": [
        {
          "title": "5 Ways Regular Massage Therapy Can Improve Your Overall Wellbeing",
          "post_url": "/5-ways-regular-massage-therapy-can-improve-your-overall-wellbeing/",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-blog-1-1024x581.webp",
          "date": "April 13, 2025",
          "category": "Wellness",
          "category_url": "/category/wellness/",
          "layout": "large"
        },
        {
          "title": "The Best Way to Relax: Himalayan Hot Stone Massage",
          "post_url": "/the-best-way-to-relax-himalayan-hot-stone-massage/",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-blog-9-300x170.webp",
          "date": "April 2, 2025",
          "category": "Wellness",
          "category_url": "/category/wellness/",
          "layout": "small"
        },
        {
          "title": "Your Skin''s Health & Vitality are Just a Facial Away!",
          "post_url": "/your-skins-health-vitality-are-just-a-facial-away/",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-blog-8-300x170.webp",
          "date": "April 4, 2025",
          "category": "Wellness",
          "category_url": "/category/wellness/",
          "layout": "small"
        },
        {
          "title": "What to Expect from Our Upcoming Shirdhara Ayurvedic Treatment",
          "post_url": "/what-to-expect-from-our-upcoming-shirdhara-ayurvedic-treatment/",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-blog-7-300x170.webp",
          "date": "April 5, 2025",
          "category": "Wellness",
          "category_url": "/category/wellness/",
          "layout": "small"
        },
        {
          "title": "Discover Natural Pain Relief with Massage Therapy",
          "post_url": "/discover-natural-pain-relief-with-massage-therapy/",
          "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-blog-6-300x170.webp",
          "date": "April 7, 2025",
          "category": "Wellness",
          "category_url": "/category/wellness/",
          "layout": "small"
        }
     ]}'::jsonb, 10, true),
    ('index', 'cta', 'cta',
     'What''s Your Next Step?', NULL, 
     'Make a step to start your journey to holistic healing with Wellness Bliss.',
     'VIew Our Services', '/prices-page', '/assets/light/wp-content/uploads/sites/4/2025/04/icon-5.svg',
     '{"extra_buttons": [
        {"text": "Choose a Specialist", "url": "/our-team/"},
        {"text": "Book an Appointment", "url": "/appointment/"},
        {"text": "Find a Location", "url": "/contacts/"}
     ]}'::jsonb, 11, true),
    ('index', 'instagram_gallery', 'gallery',
     NULL, NULL, NULL, NULL, NULL, NULL, 
     '{"instagram_images": [
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-1-768x768.webp",
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-2-768x768.webp",
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-3-768x768.webp",
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-4-768x768.webp",
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-5-768x768.webp",
        "https://wellness-bliss.cmsmasters.studio/light/wp-content/uploads/sites/4/2025/04/61-gallery-6-768x768.webp"
     ]}'::jsonb, 12, true);

-- Page Sections: About Us
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('about-us', 'hero', 'hero',
     'Why We are the Best Spa Center?', 'About Us',
     'A nurturing space where mindful rituals, natural beauty, and healing touch come together to restore your glow—inside and out.',
     NULL, NULL, NULL, '{}'::jsonb, 1, true),
    ('about-us', 'content', 'content',
     'About Us', NULL,
     'From the moment you walk in, you''ll be welcomed with warmth, professionalism, and attention to detail. Our expert therapists use premium products and the latest techniques to ensure every visit leaves you feeling confident, refreshed, and truly cared for.',
     NULL, NULL, '/assets/light/wp-content/uploads/sites/4/2025/04/61-about-2.webp', '{}'::jsonb, 2, true),
    ('about-us', 'story', 'story',
     'Our Story', NULL,
     'Step into a space created with intention—a place where your body, mind, and spirit are gently guided back into balance. At Wellness Bliss, we offer a range of holistic therapies and nurturing experiences designed to help you reconnect with your true self and restore your natural energy flow.',
     NULL, NULL, NULL,
     '{"images": ["/assets/light/wp-content/uploads/sites/4/2025/04/61-about-5.webp","/assets/light/wp-content/uploads/sites/4/2025/04/61-about-4.webp","/assets/light/wp-content/uploads/sites/4/2025/04/61-about-3.webp"]}'::jsonb, 3, true),
    ('about-us', 'team', 'team',
     'Empowering You Through Mindful Wellness', 'meet our team',
     NULL,
     'Meet the Team', '/our-team/', NULL,
     '{"placeholder_image":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profiles-placeholder.webp","team_members":[{"name":"Angela Carbone","role":"Soft Tissue Therapist","post_id":"41432","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-1.webp","profile_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/angela-carbone/","role_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/soft-tissue-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}},{"name":"Mason Goodman","role":"Reflexology Therapist","post_id":"41431","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-2.webp","profile_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/mason-goodman/","role_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/reflexology-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}},{"name":"Whitney Pratt","role":"Massage Therapist","post_id":"41430","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-3.webp","profile_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile/samuel-carter/","role_url":"https://wellness-bliss.cmsmasters.studio/light/cmsms_profile_category/massage-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}}]}'::jsonb, 4, true),
    ('about-us', 'packages', 'packages',
     'Your Journey to Balance Begins Here', 'wellness packages',
     NULL, NULL, NULL, NULL,
     '{"placeholder_image":"/assets/light/wp-content/uploads/sites/4/2025/04/61-open-service-placeholder.webp","packages":[{"title":"Serenity Starter","post_id":"44359","excerpt":"Recovering ability, mobility amd more","description":"Designed as the perfect introduction to wellness, this gentle treatment blends light massage, calming aromatherapy, and soothing energy techniques to ease tension and quiet the mind.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/serenity-starter/","button_text":"Read More","categories":"deep-restoration-journeys packages"},{"title":"Swedish Relaxation Massage","post_id":"28838","excerpt":"Recovering ability, mobility amd more","description":"Using gentle to medium pressure and flowing strokes, this massage promotes deep relaxation, improves circulation, and soothes tired muscles.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/swedish-relaxation-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"},{"title":"Balance & Recenter","post_id":"44358","excerpt":"Overcoming the challenges of limb loss","description":"This holistic session combines guided breathwork, gentle body relaxation techniques, and subtle energy balancing to align mind, body, and spirit.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/balance-recenter/","button_text":"Read More","categories":"holistic-healing-rituals packages"},{"title":"Facial Massage","post_id":"28837","excerpt":"Overcoming the challenges of limb loss","description":"Our facial massage uses light, soothing strokes to boost circulation, release tension, and enhance your skin''s natural glow.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/facial-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"},{"title":"Deep Restoration","post_id":"44357","excerpt":"Optimizing your individual abilities","description":"This intensive therapy weaves together slow massage, therapeutic touch, and calming aromatherapy to target deep physical and emotional tension.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/deep-restoration/","button_text":"Read More","categories":"deep-restoration-journeys packages"},{"title":"Aromatherapy Massage","post_id":"28836","excerpt":"Optimizing your individual abilities","description":"This massage combines gentle, flowing techniques with the healing power of essential oils chosen specifically for your needs — whether calming, energizing, or balancing.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp","url":"https://wellness-bliss.cmsmasters.studio/light/services/aromatherapy-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"}]}'::jsonb, 5, true),
    ('about-us', 'testimonials', 'testimonials',
     'Real People. Real Results', NULL, NULL,
     'More Reviews', 'https://wellness-bliss.cmsmasters.studio/light/', NULL,
     '{"testimonials":[{"author":"Mary on Hot Stone Massage","text":"Absolutely transformative experience. I felt a deep sense of peace and clarity after just one session. The energy was gentle yet powerful.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-1.webp","rating":5},{"author":"Cassy on Holistic Facial","text":"From the moment I walked in, I felt held and seen. The healing work here is incredibly intuitive and soulful.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-2.webp","rating":5},{"author":"Amanda & Lily on Moon Ritual Session","text":"This space is pure magic. The warmth, professionalism, and spiritual guidance offered are unmatched.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-3.webp","rating":5},{"author":"Noah on Deep Tissue Massage","text":"Every session feels like a reset for my mind, body, and spirit. The healing is deep, and the care is genuine.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-4.webp","rating":5}]}'::jsonb, 6, true),
    ('about-us', 'appointment', 'appointment',
     'Take the next step and schedule an appointment today', 'Schedule your visit online',
     NULL, NULL, NULL, NULL, '{}'::jsonb, 7, true);

-- Page Sections: Services
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, extra_data, sort_order, visible) VALUES
    ('services', 'hero', 'hero',
     'Services Page', NULL,
     'World-class rehabilitation solutions and individualized recovery plans, from acute care to ongoing outpatient treatment and beyond.',
     NULL, NULL, '{}'::jsonb, 1, true),
    ('services', 'packages', 'services',
     'Wellness Packages', NULL, NULL, NULL, NULL,
     '{"packages":[
       {"title":"Serenity Starter","subtitle":"Recovering ability, mobility amd more","description":"Designed as the perfect introduction to wellness, this gentle treatment blends light massage, calming aromatherapy, and soothing energy techniques to ease tension and quiet the mind.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp","url":"/services/serenity-starter/"},
       {"title":"Balance & Recenter","subtitle":"Overcoming the challenges of limb loss","description":"This holistic session combines guided breathwork, gentle body relaxation techniques, and subtle energy balancing to align mind, body, and spirit.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp","url":"/services/balance-recenter/"},
       {"title":"Deep Restoration","subtitle":"Optimizing your individual abilities","description":"This intensive therapy weaves together slow massage, therapeutic touch, and calming aromatherapy to target deep physical and emotional tension.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp","url":"/services/deep-restoration/"},
       {"title":"Moon & Soul Ritual","subtitle":"Restoring the skills to rebuild your life","description":"A nurturing, soulful experience designed to leave you feeling aligned, illuminated, and deeply at peace.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-5.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-5.webp","url":"/services/moon-soul-ritual/"},
       {"title":"Inner Glow Detox","subtitle":"Discovering the path to independence","description":"Perfect for those seeking to refresh both body and mind, Inner Glow Detox leaves you feeling lighter, brighter, and full of vibrant energy.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-4.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-4.webp","url":"/services/inner-glow-detox/"},
       {"title":"Blissful Renewal Day","subtitle":"Finding solutions to complex needs","description":"Perfect for those seeking a complete reset, this experience leaves you deeply restored, glowing, and ready to embrace life with renewed energy.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-6.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-6.webp","url":"/services/blissful-renewal-day/"}
     ]}'::jsonb, 2, true),
    ('services', 'services_list', 'services',
     'Our Services', NULL, NULL, NULL, NULL,
     '{"services":[
       {"title":"Swedish Relaxation Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp","url":"/services/swedish-relaxation-massage/"},
       {"title":"Facial Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp","url":"/services/facial-massage/"},
       {"title":"Aromatherapy Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp","url":"/services/aromatherapy-massage/"},
       {"title":"Hot Stone Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp","url":"/services/hot-stone-massage/"},
       {"title":"Deep Tissue Therapy","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp","url":"/services/deep-tissue-therapy/"},
       {"title":"Reflexology Therapy","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp","url":"/services/reflexology-therapy/"}
     ]}'::jsonb, 3, true),
    ('services', 'consultation', 'cta',
     'Free Consultation', 'Get a special 50% new patient discount and unleash your health.',
     'Whether you''re seeking pain relief or overall wellness, our expert practitioners are here to help you achieve your health goals. Don''t miss out on this opportunity to invest in your health at half the price!',
     'Find Out More', '/contacts/',
     '{"image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-services-2-1024x820.webp"}'::jsonb, 4, true);

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


-- 5. SERVICES DATA

-- Insert Services
INSERT INTO services (slug, title, category, short_description, full_description, hero_image_url, icon_url, sidebar_links, visible, sort_order) VALUES
    ('aromatherapy-massage', 'Aromatherapy Massage', 'Sensory Relaxation Therapies',
     'This massage combines gentle, flowing techniques with the healing power of essential oils chosen specifically for your needs — whether calming, energizing, or balancing.',
     'At our studio, every service is designed to nurture your body, soothe your mind, and uplift your spirit. Whether you seek deep physical healing, emotional balance, or simply a moment of quiet peace, you''ll find a space here to reconnect with yourself. Our carefully curated massages, facials, energy therapies, and holistic rituals are crafted to meet you exactly where you are on your wellness journey.

We blend skilled techniques with natural elements like essential oils, warm stones, and mindful touch to create an experience that goes far beyond relaxation. Each treatment is a personalized invitation to release tension, restore balance, and renew your inner glow.

We honor the importance of slow moments, intentional care, and the healing power of touch. No matter which path you choose — whether a gentle massage, a detoxifying ritual, or a soulful energy reset — you will leave feeling lighter, centered, and beautifully restored.

This is your time to pause, breathe deeply, and return to yourself.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg',
     '[{"title":"Swedish Relaxation Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/swedish-relaxation-massage/"},{"title":"Serenity Starter","url":"https://wellness-bliss.cmsmasters.studio/light/services/serenity-starter/"},{"title":"Facial Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/facial-massage/"},{"title":"Balance & Recenter","url":"https://wellness-bliss.cmsmasters.studio/light/services/balance-recenter/"},{"title":"Aromatherapy Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/aromatherapy-massage/"},{"title":"Deep Restoration","url":"https://wellness-bliss.cmsmasters.studio/light/services/deep-restoration/"},{"title":"Hot Stone Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/hot-stone-massage/"},{"title":"Moon & Soul Ritual","url":"https://wellness-bliss.cmsmasters.studio/light/services/moon-soul-ritual/"}]'::jsonb,
     true, 1),
     
    ('swedish-relaxation-massage', 'Swedish Relaxation Massage', 'Sensory Relaxation Therapies',
     'Using gentle to medium pressure and flowing strokes, this massage promotes deep relaxation, improves circulation, and soothes tired muscles.',
     'Swedish Relaxation Massage is the foundation of modern massage therapy. Using long, flowing strokes combined with gentle kneading and circular movements, this treatment helps ease muscle tension while promoting a profound sense of calm and well-being.

Perfect for those new to massage or seeking pure relaxation, this technique enhances circulation, reduces stress hormones, and supports your body''s natural healing processes.

Each session is tailored to your comfort level, ensuring you leave feeling refreshed, balanced, and deeply at ease.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg',
     '[{"title":"Swedish Relaxation Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/swedish-relaxation-massage/"},{"title":"Facial Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/facial-massage/"},{"title":"Aromatherapy Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/aromatherapy-massage/"},{"title":"Hot Stone Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/hot-stone-massage/"},{"title":"Deep Tissue Therapy","url":"https://wellness-bliss.cmsmasters.studio/light/services/deep-tissue-therapy/"},{"title":"Reflexology Therapy","url":"https://wellness-bliss.cmsmasters.studio/light/services/reflexology-therapy/"}]'::jsonb,
     true, 2),
     
    ('hot-stone-massage', 'Hot Stone Massage', 'Sensory Relaxation Therapies',
     'Smooth, heated stones are placed on key points of the body and used in flowing massage strokes to ease muscle tension and enhance circulation.',
     'Experience the soothing warmth of smooth, heated stones combined with expert massage techniques. Hot Stone Massage uses carefully placed volcanic stones to melt away deep-seated tension while promoting relaxation and energy flow.

The gentle heat penetrates muscle tissue, allowing for deeper relaxation without intense pressure. This treatment is ideal for those with chronic muscle tension, stress, or simply seeking a uniquely calming experience.

Leave feeling grounded, warm, and completely at peace.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg',
     '[{"title":"Hot Stone Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/hot-stone-massage/"},{"title":"Swedish Relaxation Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/swedish-relaxation-massage/"},{"title":"Deep Tissue Therapy","url":"https://wellness-bliss.cmsmasters.studio/light/services/deep-tissue-therapy/"},{"title":"Aromatherapy Massage","url":"https://wellness-bliss.cmsmasters.studio/light/services/aromatherapy-massage/"}]'::jsonb,
     true, 3);

-- Insert Service FAQs for Aromatherapy Massage
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    (1, 'How do I know which service is best for me?',
     'If you''re looking to relax your body, a massage or body treatment might be perfect. If you''re seeking emotional balance or stress relief, a meditation or energy healing session could be ideal. Feel free to contact us — we''re happy to guide you to the right experience for your needs!', 1),
    (1, 'What should I wear to my appointment?',
     'Wear whatever makes you feel most comfortable! For massages and body treatments, we provide privacy, cozy linens, and soft robes. For meditation and energy sessions, light, loose clothing is ideal to help you fully relax.', 2),
    (1, 'Are the aromatherapy oils and facial products natural?',
     'Absolutely! We use only high-quality, natural, and ethically sourced ingredients. Every product is chosen to nourish your body, uplift your spirit, and support overall wellness.', 3),
    (1, 'Can I combine two services in one visit?',
     'Yes! Many of our guests love to pair services, like a massage followed by a meditation or facial. Let us know when you book, and we''ll help create a custom relaxation experience just for you.', 4),
    (1, 'What if it''s my first time trying meditation or energy healing?',
     'That''s wonderful — you''re in good hands! Our practitioners are experienced in guiding beginners gently and comfortably through each session. You''ll be supported every step of the way, with no pressure and no expectations.', 5);

-- Insert Service FAQs for Swedish Relaxation Massage
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    (2, 'Is Swedish massage good for beginners?',
     'Absolutely! Swedish massage is perfect for first-timers. The gentle, flowing techniques help you ease into the experience while providing deep relaxation and stress relief.', 1),
    (2, 'How long does a typical Swedish massage session last?',
     'Sessions typically range from 60 to 90 minutes. We recommend starting with 60 minutes if you''re new to massage, and extending to 90 minutes for a more comprehensive full-body experience.', 2),
    (2, 'Will I be sore after the massage?',
     'Swedish massage uses gentle to medium pressure, so most people don''t experience soreness afterward. You may feel deeply relaxed and perhaps a bit sleepy — this is completely normal and a sign your body is releasing tension.', 3);

-- Insert Service FAQs for Hot Stone Massage
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    (3, 'How hot are the stones?',
     'The stones are heated to a comfortable, therapeutic temperature — warm enough to relax muscles deeply, but never uncomfortably hot. We always check the temperature before placing them on your body.', 1),
    (3, 'Is hot stone massage safe for everyone?',
     'Hot stone massage is safe for most people. However, we don''t recommend it if you have certain conditions like high blood pressure, diabetes, or pregnancy. Please let us know about any health concerns during booking.', 2),
    (3, 'Can I request cooler or warmer stones?',
     'Absolutely! Your comfort is our priority. Let your therapist know if you''d prefer the stones to be warmer or cooler at any point during the session.', 3);


-- 6. ROW LEVEL SECURITY
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE pages ENABLE ROW LEVEL SECURITY;
ALTER TABLE navigation ENABLE ROW LEVEL SECURITY;
ALTER TABLE page_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_faqs ENABLE ROW LEVEL SECURITY;

-- Allow public read/write (for demo/development)
CREATE POLICY "Allow all for site_settings" ON site_settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for pages" ON pages FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for navigation" ON navigation FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for page_sections" ON page_sections FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for services" ON services FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for service_faqs" ON service_faqs FOR ALL USING (true) WITH CHECK (true);

