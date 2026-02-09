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
    ('contacts_label', 'Contacts')
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
     'Explore Our Services', '/services-page', NULL, '{}'::jsonb, 1, true),
    ('index', 'intro', 'intro',
     'Welcome to Wellness Bliss', NULL, 
     'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm. Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out.',
     NULL, NULL, NULL, '{}'::jsonb, 2, true),
    ('index', 'about', 'about',
     'Reconnect with Yourself. Holistic Massage in a Space Inspired by Nature''s Calm',
     'Welcome to Wellness Bliss',
     'Let your body unwind and your spirit breathe — our treatments are designed to restore balance, inside and out. At Wellness Bliss, we believe true healing begins with presence and touch.',
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

