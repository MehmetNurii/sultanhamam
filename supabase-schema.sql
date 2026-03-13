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
    ('site_title', 'Sultan Hamam Fethiye'),
    ('site_description', 'Authentic Turkish Bath & Spa Experience in Fethiye'),
    ('phone', '+90 252 622 0433'),
    ('email', 'info@sultanhamamfethiye.com'),
    ('address', 'Foça Mahallesi, 1030 Sokak No:142, 48300 Fethiye/Muğla'),
    ('facebook', 'https://facebook.com/sultanhamamfethiye'),
    ('instagram', 'https://instagram.com/sultanahammam'),
    ('twitter', ''),
    ('hero_title', 'Authentic Turkish Bath & Spa Experience'),
    ('hero_subtitle', 'Discover the Ancient Tradition of Purification, Renewal, and Deep Relaxation in the Heart of Fethiye'),
    ('footer_discount_text', 'Book your Sultan Hamam experience today and discover true relaxation.'),
    ('footer_newsletter_title', 'Sign up to Newsletter'),
    ('footer_newsletter_button', 'Sign Up'),
    ('site_url', '/'),
    ('home_two_url', '/'),
    ('logo_url', '/assets/light/wp-content/uploads/sites/4/2025/05/logo-2.svg'),
    ('logo_alt', 'Sultan Hamam Fethiye'),
    ('logo_title', 'Sultan Hamam Fethiye'),
    ('work_hours_weekday', 'Her Gün: 10:00 - 23:45'),
    ('work_hours_saturday', ''),
    ('work_hours_sunday', ''),
    ('copyright_text', '© 2026 Sultan Hamam Fethiye - All Rights Reserved'),
    ('sample_site_text', ''),
    ('contacts_url', '/contacts'),
    ('book_appointment_text', 'Book an Appointment'),
    ('book_appointment_description', 'Reserve your spot for an unforgettable Turkish bath and spa experience.'),
    ('book_visit_text', 'Book a Visit'),
    ('book_online_text', 'Book Online'),
    ('view_directions_text', 'View Directions'),
    ('view_directions_url', '/contacts'),
    ('address_label', 'Address'),
    ('work_hours_label', 'Work Hours'),
    ('contacts_label', 'Contacts'),
    ('header_navigation', '[{"title":"Home","url":"/","visible":true,"children":[]},{"title":"About Us","url":"/about-us","visible":true,"children":[]},{"title":"Services","url":"#","visible":true,"children":[{"title":"All Services","url":"/services","visible":true,"children":[]},{"title":"Turkish Bath","url":"/services/turkish-bath/","visible":true,"children":[]},{"title":"Pasha Turkish Bath","url":"/services/pasha-turkish-bath/","visible":true,"children":[]},{"title":"Swedish Massage","url":"/services/swedish-massage/","visible":true,"children":[]},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/","visible":true,"children":[]},{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/","visible":true,"children":[]},{"title":"Hot Stone Massage","url":"/services/hot-stone-massage/","visible":true,"children":[]},{"title":"Bali Massage","url":"/services/bali-massage/","visible":true,"children":[]},{"title":"Reflexology","url":"/services/reflexology/","visible":true,"children":[]}]},{"title":"Packages","url":"#","visible":true,"children":[{"title":"Package 1","url":"/services/package-1/","visible":true,"children":[]},{"title":"Package 2","url":"/services/package-2/","visible":true,"children":[]},{"title":"Package 3","url":"/services/package-3/","visible":true,"children":[]},{"title":"Silver Package","url":"/services/silver-package/","visible":true,"children":[]},{"title":"Gold Package","url":"/services/gold-package/","visible":true,"children":[]}]},{"title":"Prices","url":"/prices-page","visible":true,"children":[]},{"title":"Contacts","url":"/contacts","visible":true,"children":[]}]'),
    ('footer_navigation', '[{"title":"Home","url":"/","visible":true},{"title":"About Us","url":"/about-us","visible":true},{"title":"Services","url":"/services","visible":true},{"title":"Prices","url":"/prices-page","visible":true},{"title":"Contacts","url":"/contacts","visible":true}]')
ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value;

-- Pages
INSERT INTO pages (slug, title, meta_title, meta_description, visible) VALUES
    ('index', 'Home', 'Sultan Hamam Fethiye - Authentic Turkish Bath & Spa', 'Experience the ancient tradition of Turkish bath, hammam scrub, foam massage, and relaxation therapies in the heart of Fethiye.', true),
    ('services', 'Services', 'Our Services - Sultan Hamam Fethiye', 'Discover our Turkish bath rituals, relaxation massages, medical massages, and wellness packages.', true),
    ('about-us', 'About Us', 'About Us - Sultan Hamam Fethiye', 'Learn about Sultan Hamam, our story, and our commitment to authentic Turkish bath culture in Fethiye.', true),
    ('our-team', 'Our Team', 'Our Team - Sultan Hamam Fethiye', 'Meet our experienced therapists and hammam attendants.', true),
    ('prices-page', 'Prices', 'Prices - Sultan Hamam Fethiye', 'View our service prices for Turkish bath, massages, and spa packages.', true),
    ('contacts', 'Contact', 'Contact Us - Sultan Hamam Fethiye', 'Get in touch for appointments and directions to Sultan Hamam in Fethiye.', true),
    ('appointment', 'Appointment', 'Book an Appointment - Sultan Hamam Fethiye', 'Schedule your Turkish bath or massage appointment online.', true),
    ('services-id', 'Service Details', 'Service Details - Sultan Hamam Fethiye', 'Detailed information about our Turkish bath and spa services.', true);

-- Navigation: Header + Footer hierarchical menu
INSERT INTO navigation (id, title, url, sort_order, visible, parent_id, location, extra_data) VALUES
    -- HEADER TOP-LEVEL
    (1, 'Home', '/', 1, true, NULL, 'header', '{}'),
    (2, 'About Us', '/about-us', 2, true, NULL, 'header', '{}'),
    (3, 'Services', '#', 3, true, NULL, 'header', '{}'),
    (4, 'Packages', '#', 4, true, NULL, 'header', '{}'),
    (5, 'Prices', '/prices-page', 5, true, NULL, 'header', '{}'),
    (6, 'Contacts', '/contacts', 6, true, NULL, 'header', '{}'),
    -- Services sub-menu
    (7, 'All Services', '/services', 1, true, 3, 'header', '{}'),
    (8, 'Turkish Bath', '/services/turkish-bath/', 2, true, 3, 'header', '{}'),
    (9, 'Pasha Turkish Bath', '/services/pasha-turkish-bath/', 3, true, 3, 'header', '{}'),
    (10, 'Swedish Massage', '/services/swedish-massage/', 4, true, 3, 'header', '{}'),
    (11, 'Aromatherapy Massage', '/services/aromatherapy-massage/', 5, true, 3, 'header', '{}'),
    (12, 'Deep Tissue Massage', '/services/deep-tissue-massage/', 6, true, 3, 'header', '{}'),
    (13, 'Hot Stone Massage', '/services/hot-stone-massage/', 7, true, 3, 'header', '{}'),
    (14, 'Bali Massage', '/services/bali-massage/', 8, true, 3, 'header', '{}'),
    (15, 'Reflexology', '/services/reflexology/', 9, true, 3, 'header', '{}'),
    -- Packages sub-menu
    (16, 'Package 1', '/services/package-1/', 1, true, 4, 'header', '{}'),
    (17, 'Package 2', '/services/package-2/', 2, true, 4, 'header', '{}'),
    (18, 'Package 3', '/services/package-3/', 3, true, 4, 'header', '{}'),
    (19, 'Silver Package', '/services/silver-package/', 4, true, 4, 'header', '{}'),
    (20, 'Gold Package', '/services/gold-package/', 5, true, 4, 'header', '{}'),
    -- FOOTER navigation
    (21, 'Home', '/', 1, true, NULL, 'footer', '{}'),
    (22, 'About Us', '/about-us', 2, true, NULL, 'footer', '{}'),
    (23, 'Services', '/services', 3, true, NULL, 'footer', '{}'),
    (24, 'Prices', '/prices-page', 4, true, NULL, 'footer', '{}'),
    (25, 'Contacts', '/contacts', 5, true, NULL, 'footer', '{}');

SELECT setval('navigation_id_seq', 25);
-- Page Sections: Global
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, sort_order) VALUES
    ('_global', 'popup', 'popup',
     'Discover the Authentic Turkish Bath Experience',
     'WELCOME TO SULTAN HAMAM!',
     'Enjoy a traditional hammam ritual with scrub, foam massage, sauna, and steam room. Swimming pool and drinks included with every bath package.',
     'Book Now', '/contacts', 1);

-- Page Sections: Home (index)
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('index', 'hero', 'hero', 
     'Authentic Turkish Bath & Spa Experience', NULL, NULL,
     'Explore Our Services', '/services', NULL, '{}'::jsonb, 1, true),
    ('index', 'intro', 'intro',
     'Welcome to Sultan Hamam Fethiye',
     'Discover the Ancient Tradition of Purification, Renewal, and Deep Relaxation',
     'Step into a world of warmth and tradition. Our authentic Turkish bath experience combines centuries-old rituals with modern comfort to cleanse, rejuvenate, and restore your body and mind.',
     NULL, NULL, NULL, '{}'::jsonb, 2, true),
    ('index', 'about', 'about',
     NULL, NULL,
     'At Sultan Hamam, we preserve the timeless tradition of the Turkish bath. Our skilled hammam attendants guide you through a purification ritual of sauna, steam, exfoliating scrub, and luxurious foam massage — all on our heated marble stone. Every visit is a journey of renewal for body and spirit.',
     'More About Us', '/about-us', '/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-3.webp', '{}'::jsonb, 3, true),
    ('index', 'services', 'services',
     'Our Services', NULL, NULL,
     'View all Services', '/services', NULL,
     '{"services": [
        {
          "title": "Turkish Bath Hammam",
          "description": "A purification ritual with sauna, steam room, exfoliating scrub (kese), and luxurious foam massage on heated marble. 60 minutes of tradition.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp",
          "button_text": "Read More",
          "url": "/services/turkish-bath/"
        },
        {
          "title": "Swedish Massage",
          "description": "A classic full-body massage using effleurage, petrissage, and light percussion techniques. Promotes deep relaxation and improves circulation. 60 min.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp",
          "button_text": "Read More",
          "url": "/services/swedish-massage/"
        },
        {
          "title": "Aromatherapy Massage",
          "description": "A relaxing full-body massage with aromatic essential oils selected for your needs — calming, energizing, or balancing. 60 min.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp",
          "button_text": "Read More",
          "url": "/services/aromatherapy-massage/"
        },
        {
          "title": "Hot Stone Massage",
          "description": "Heated natural basalt stones are placed on key energy points and used in flowing massage strokes for deep muscle relaxation. 90 min.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp",
          "button_text": "Read More",
          "url": "/services/hot-stone-massage/"
        },
        {
          "title": "Deep Tissue Massage",
          "description": "Targets chronic muscle pain and deep-seated stiffness with focused pressure to release muscle knots and tension. 60 min.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp",
          "button_text": "Read More",
          "url": "/services/deep-tissue-massage/"
        },
        {
          "title": "Reflexology",
          "description": "Specialized pressure applied to reflex points on the feet to stimulate related organs and systems in the body. 30 min.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp",
          "button_text": "Read More",
          "url": "/services/reflexology/"
        }
     ]}'::jsonb, 4, true),
    ('index', 'features', 'features',
     'Why Choose Sultan Hamam?',
     'Experience Centuries of Turkish Bath Tradition in the Heart of Fethiye',
     NULL, 'Find out More', '/services', NULL,
     '{"features": [
        {"title": "Authentic Hammam Ritual", "description": "A genuine Turkish bath experience with traditional scrub and foam massage on heated marble, performed by skilled attendants."},
        {"title": "Complete Spa Facilities", "description": "Enjoy our sauna, steam room, swimming pool, and relaxation areas. All drinks included with every bath package."},
        {"title": "Expert Therapists", "description": "Our licensed massage therapists offer a wide range of treatments from Swedish and deep tissue to medical massage and cupping."},
        {"title": "Relaxation & Renewal", "description": "Leave feeling lighter, cleaner, and deeply relaxed. Our treatments detoxify, improve circulation, and restore your energy."}
     ],
     "counter_number": "20+",
     "counter_text": "Years of authentic Turkish bath tradition"
    }'::jsonb, 5, true),
    ('index', 'team', 'team',
     'Our Experienced Team', 
     'Skilled therapists and hammam attendants dedicated to your well-being.',
     NULL,
     'Meet the Team', '/our-team', NULL,
     '{"team_members": []}'::jsonb, 6, false),
    ('index', 'gallery', 'gallery',
     'Photo Gallery',
     'A glimpse into the Sultan Hamam experience',
     NULL, NULL, NULL, NULL, 
     '{"gallery_images": [
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-5.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-6.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-7.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-8.webp",
        "/assets/light/wp-content/uploads/sites/4/2025/04/61-home-2-9.webp"
     ]}'::jsonb, 7, true),
    ('index', 'pricing', 'pricing',
     'Our Prices', NULL, 
     'We offer transparent pricing for all our services. Swimming pool and drinks are included with all Turkish bath packages.',
     'Full Price List', '/prices-page', NULL,
     '{"pricing_categories": [
        {
          "title": "Turkish Bath",
          "description": "Traditional hammam experience with scrub and foam massage.",
          "icon_class": "cmsms-demo-icons-wellness-bliss",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "items": [
            {"name": "Entrance & Facility Use (Max 3 hrs)", "price": "€25"},
            {"name": "Turkish Bath - Scrub & Foam (60 min)", "price": "€40"},
            {"name": "Pasha Turkish Bath - Extended (60 min)", "price": "€55"}
          ]
        },
        {
          "title": "Relaxation Massages",
          "description": "A range of relaxation and therapeutic massage treatments.",
          "icon_class": "cmsms-demo-icons-wellness-15",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "items": [
            {"name": "Back, Neck & Shoulders - 30 min", "price": "€30"},
            {"name": "Back, Neck, Shoulders & Legs - 45 min", "price": "€40"},
            {"name": "Swedish Full Body - 60 min", "price": "€50"},
            {"name": "Aromatherapy Full Body - 60 min", "price": "€55"},
            {"name": "Hot Stone Full Body - 90 min", "price": "€70"},
            {"name": "Bali Massage Full Body - 60 min", "price": "€55"}
          ]
        },
        {
          "title": "Medical Massages",
          "description": "Therapeutic treatments for pain relief and recovery.",
          "icon_class": "cmsms-demo-icons-wellness-11",
          "detail_url": "/prices-page/",
          "detail_text": "View Details",
          "items": [
            {"name": "Medical Massage + Cupping - 30 min", "price": "€35"},
            {"name": "Medical Massage + Cupping - 45 min", "price": "€45"},
            {"name": "Full Body Medical - 60 min", "price": "€55"},
            {"name": "Sports Massage - 60 min", "price": "€55"},
            {"name": "Deep Tissue Full Body - 60 min", "price": "€55"},
            {"name": "Lymph Drainage Full Body - 60 min", "price": "€55"}
          ]
        }
     ]}'::jsonb, 8, true),
    ('index', 'testimonials', 'testimonials',
     'What our guests say about us',
     'Highly rated on Google by hundreds of happy guests',
     NULL, NULL, NULL, NULL, 
     '{"testimonials": [
        {
          "name": "Guest Review",
          "text": "An absolutely wonderful Turkish bath experience. The staff were incredibly professional and the facilities were spotless. The scrub and foam massage left my skin feeling amazing. Highly recommended for anyone visiting Fethiye!",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-1.webp",
          "rating": 5
        },
        {
          "name": "Guest Review",
          "text": "Sultan Hamam is a must-visit in Fethiye. The traditional hammam ritual was authentic and rejuvenating. The sauna, steam room, and pool were all excellent. A truly relaxing experience from start to finish.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-2.webp",
          "rating": 5
        },
        {
          "name": "Guest Review",
          "text": "Best spa experience we have had on our holiday. The massage therapist was very skilled and attentive. The whole atmosphere is calming and welcoming. Will definitely return next time we are in Fethiye.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-3.webp",
          "rating": 5
        },
        {
          "name": "Guest Review",
          "text": "We booked the Gold Package and it was worth every penny. Turkish bath followed by a full body massage, face mask, and foot treatment. Left feeling completely renewed. The team is wonderful.",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-4.webp",
          "rating": 5
        },
        {
          "name": "Guest Review",
          "text": "Outstanding hammam experience. The kese scrub was thorough yet gentle, and the foam massage was pure bliss. The facilities including the pool are a great bonus. Top quality service in Fethiye!",
          "image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-testimonial-5.webp",
          "rating": 5
        }
     ]}'::jsonb, 9, true),
    ('index', 'cta', 'cta',
     'Ready for Your Turkish Bath Experience?', NULL, 
     'Take the next step towards relaxation and renewal at Sultan Hamam Fethiye.',
     'View Our Services', '/services', '/assets/light/wp-content/uploads/sites/4/2025/04/icon-5.svg',
     '{"extra_buttons": [
        {"text": "View Prices", "url": "/prices-page/"},
        {"text": "Book an Appointment", "url": "/appointment/"},
        {"text": "Find Us", "url": "/contacts/"}
     ]}'::jsonb, 10, true),
    ('index', 'instagram_gallery', 'gallery',
     NULL, NULL, NULL, NULL, NULL, NULL, 
     '{"instagram_images": [
        "/wp-content/uploads/sites/4/2025/04/61-gallery-1-768x768.webp",
        "/wp-content/uploads/sites/4/2025/04/61-gallery-2-768x768.webp",
        "/wp-content/uploads/sites/4/2025/04/61-gallery-3-768x768.webp",
        "/wp-content/uploads/sites/4/2025/04/61-gallery-4-768x768.webp",
        "/wp-content/uploads/sites/4/2025/04/61-gallery-5-768x768.webp",
        "/wp-content/uploads/sites/4/2025/04/61-gallery-6-768x768.webp"
     ]}'::jsonb, 11, true);


-- Page Sections: About Us
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('about-us', 'hero', 'hero',
     'About Sultan Hamam Fethiye', 'About Us',
     'A traditional Turkish bath where centuries-old purification rituals meet modern comfort and care.',
     NULL, NULL, NULL, '{}'::jsonb, 1, true),
    ('about-us', 'content', 'content',
     'About Us', NULL,
     'Sultan Hamam brings the authentic Turkish bath experience to the heart of Fethiye. From the moment you step inside, you will be welcomed with genuine hospitality and guided through a centuries-old ritual of cleansing and renewal. Our skilled attendants and licensed therapists ensure every visit is safe, comfortable, and deeply rejuvenating.',
     NULL, NULL, '/assets/light/wp-content/uploads/sites/4/2025/04/61-about-2.webp', '{}'::jsonb, 2, true),
    ('about-us', 'story', 'story',
     'Our Story', NULL,
     'The Turkish bath tradition stretches back over a thousand years. At Sultan Hamam, we honour this heritage while providing modern facilities including sauna, steam room, and swimming pool. Our hammam ritual — kese scrub and foam massage on heated marble — is performed by experienced attendants who understand the art of traditional body care. We also offer a comprehensive menu of relaxation and medical massages.',
     NULL, NULL, NULL,
     '{"images": ["/assets/light/wp-content/uploads/sites/4/2025/04/61-about-5.webp","/assets/light/wp-content/uploads/sites/4/2025/04/61-about-4.webp","/assets/light/wp-content/uploads/sites/4/2025/04/61-about-3.webp"]}'::jsonb, 3, true),
    ('about-us', 'team', 'team',
     'Our Experienced Team', 'meet our team',
     NULL,
     'Meet the Team', '/our-team/', NULL,
     '{"placeholder_image":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profiles-placeholder.webp","team_members":[{"name":"Angela Carbone","role":"Soft Tissue Therapist","post_id":"41432","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-1.webp","profile_url":"/cmsms_profile/angela-carbone/","role_url":"/cmsms_profile_category/soft-tissue-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}},{"name":"Mason Goodman","role":"Reflexology Therapist","post_id":"41431","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-2.webp","profile_url":"/cmsms_profile/mason-goodman/","role_url":"/cmsms_profile_category/reflexology-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}},{"name":"Whitney Pratt","role":"Massage Therapist","post_id":"41430","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profile-3.webp","profile_url":"/cmsms_profile/samuel-carter/","role_url":"/cmsms_profile_category/massage-therapist/","social_links":{"facebook":"/assets/external_aHR0cHM6Ly93d3cuZmFjZWJvb2suY29t.wpstudio","twitter":"/assets/external_aHR0cHM6Ly90d2l0dGVyLmNvbS9kZXZf.html","linkedin":"https://www.linkedin.com/in/cmsmasters-wordpress-team-44b35940"}}]}'::jsonb, 4, false),
    ('about-us', 'packages', 'packages',
     'Your Journey to Balance Begins Here', 'wellness packages',
     NULL, NULL, NULL, NULL,
     '{"placeholder_image":"/assets/light/wp-content/uploads/sites/4/2025/04/61-open-service-placeholder.webp","packages":[{"title":"Serenity Starter","post_id":"44359","excerpt":"Recovering ability, mobility amd more","description":"Designed as the perfect introduction to wellness, this gentle treatment blends light massage, calming aromatherapy, and soothing energy techniques to ease tension and quiet the mind.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp","url":"/services/serenity-starter/","button_text":"Read More","categories":"deep-restoration-journeys packages"},{"title":"Swedish Relaxation Massage","post_id":"28838","excerpt":"Recovering ability, mobility amd more","description":"Using gentle to medium pressure and flowing strokes, this massage promotes deep relaxation, improves circulation, and soothes tired muscles.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp","url":"/services/swedish-relaxation-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"},{"title":"Balance & Recenter","post_id":"44358","excerpt":"Overcoming the challenges of limb loss","description":"This holistic session combines guided breathwork, gentle body relaxation techniques, and subtle energy balancing to align mind, body, and spirit.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp","url":"/services/balance-recenter/","button_text":"Read More","categories":"holistic-healing-rituals packages"},{"title":"Facial Massage","post_id":"28837","excerpt":"Overcoming the challenges of limb loss","description":"Our facial massage uses light, soothing strokes to boost circulation, release tension, and enhance your skin''s natural glow.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp","url":"/services/facial-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"},{"title":"Deep Restoration","post_id":"44357","excerpt":"Optimizing your individual abilities","description":"This intensive therapy weaves together slow massage, therapeutic touch, and calming aromatherapy to target deep physical and emotional tension.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp","url":"/services/deep-restoration/","button_text":"Read More","categories":"deep-restoration-journeys packages"},{"title":"Aromatherapy Massage","post_id":"28836","excerpt":"Optimizing your individual abilities","description":"This massage combines gentle, flowing techniques with the healing power of essential oils chosen specifically for your needs — whether calming, energizing, or balancing.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp","url":"/services/aromatherapy-massage/","button_text":"Read More","categories":"sensory-relaxation-therapies"}]}'::jsonb, 5, true),
    ('about-us', 'testimonials', 'testimonials',
     'What Our Guests Say', NULL, NULL,
     'More Reviews', '/', NULL,
     '{"testimonials":[{"author":"Mary on Hot Stone Massage","text":"Absolutely transformative experience. I felt a deep sense of peace and clarity after just one session. The energy was gentle yet powerful.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-1.webp","rating":5},{"author":"Cassy on Holistic Facial","text":"From the moment I walked in, I felt held and seen. The healing work here is incredibly intuitive and soulful.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-2.webp","rating":5},{"author":"Amanda & Lily on Moon Ritual Session","text":"This space is pure magic. The warmth, professionalism, and spiritual guidance offered are unmatched.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-3.webp","rating":5},{"author":"Noah on Deep Tissue Massage","text":"Every session feels like a reset for my mind, body, and spirit. The healing is deep, and the care is genuine.","image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-home-1-testimonial-4.webp","rating":5}]}'::jsonb, 6, true),
    ('about-us', 'appointment', 'appointment',
     'Ready to experience the authentic Turkish bath?', 'Schedule your visit online',
     NULL, NULL, NULL, NULL, '{}'::jsonb, 7, true);

-- Page Sections: Services
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, extra_data, sort_order, visible) VALUES
    ('services', 'hero', 'hero',
     'Our Services', NULL,
     'From the traditional Turkish bath ritual to a wide range of relaxation and medical massages, Sultan Hamam offers a complete wellness experience.',
     NULL, NULL, '{}'::jsonb, 1, true),
    ('services', 'packages', 'services',
     'Spa Packages', NULL, NULL, NULL, NULL,
     '{"packages":[
       {"title":"Package 1","subtitle":"Bath + Back Massage","description":"Sauna, Steam Room, Scrub, Foam Massage and Back, Neck & Shoulders Massage 30 min. Swimming pool and drinks included.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp","url":"/services/package-1/"},
       {"title":"Package 2","subtitle":"Bath + Extended Massage","description":"Sauna, Steam Room, Scrub, Foam Massage and Back, Neck, Shoulders & Legs Massage 45 min. Swimming pool and drinks included.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp","url":"/services/package-2/"},
       {"title":"Package 3","subtitle":"Bath + Full Body Massage","description":"Sauna, Steam Room, Scrub, Foam Massage and Swedish Full Body Massage 1 hour. Swimming pool and drinks included.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp","url":"/services/package-3/"},
       {"title":"Silver Package","subtitle":"Bath + Massage + Face Mask","description":"Sauna, Steam Room, Scrub, Foam Massage, Swedish Full Body Massage 1 hour, and Face Mask. Swimming pool and drinks included.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-4.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-4.webp","url":"/services/silver-package/"},
       {"title":"Gold Package","subtitle":"The Complete Experience","description":"Sauna, Steam Room, Scrub, Foam Massage, Swedish Full Body Massage 1 hour, Face Mask, and Hard Skin Removal. Swimming pool and drinks included.","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-5.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-5.webp","url":"/services/gold-package/"}
     ]}'::jsonb, 2, true),
    ('services', 'services_list', 'services',
     'Individual Services', NULL, NULL, NULL, NULL,
     '{"services":[
       {"title":"Turkish Bath Hammam","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp","url":"/services/turkish-bath/"},
       {"title":"Swedish Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp","url":"/services/swedish-massage/"},
       {"title":"Aromatherapy Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp","url":"/services/aromatherapy-massage/"},
       {"title":"Hot Stone Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp","url":"/services/hot-stone-massage/"},
       {"title":"Deep Tissue Massage","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp","url":"/services/deep-tissue-massage/"},
       {"title":"Reflexology","icon_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg","bg_image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp","url":"/services/reflexology/"}
     ]}'::jsonb, 3, true),
    ('services', 'consultation', 'cta',
     'Book Your Visit', 'Swimming pool and all drinks are included with every bath package.',
     'Whether you are looking for a traditional Turkish bath, a relaxing massage, or a complete spa day, our experienced team is here to give you an unforgettable experience in Fethiye.',
     'Contact Us', '/contacts/',
     '{"image_url":"/assets/light/wp-content/uploads/sites/4/2025/04/61-services-2-1024x820.webp"}'::jsonb, 4, true);

-- Page Sections: Contacts
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    -- Hero (contact üstü)
    ('contacts', 'hero', 'hero',
     'Visit Sultan Hamam in Fethiye', 'CONTACT US',
     NULL,
     NULL, NULL, NULL, '{}'::jsonb, 1, true),
    ('contacts', 'info', 'contact',
     'Contact Information', NULL,
     'We are located in the heart of Fethiye. Book your visit online, call us, or simply drop by.',
     NULL, NULL, NULL, '{}'::jsonb, 2, true),
    -- Location card
    ('contacts', 'locations', 'locations',
     'Our Location', NULL,
     NULL, NULL, NULL, NULL,
     '{
        "locations": [
          {
            "name": "Sultan Hamam Fethiye",
            "image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-contacts-2.webp",
            "address_html": "Foça Mahallesi, 1030 Sokak No:142<br>48300 Fethiye/Muğla",
            "hours_html": "Her Gün<br>10:00 – 23:45",
            "button_text": "Get Directions",
            "button_url": "https://maps.google.com/?q=Sultan+Hamam+Fethiye"
          }
        ]
      }'::jsonb,
     3, true),
    ('contacts', 'ask_question', 'contact_form',
     'Ask a Question', NULL,
     'If you have any questions about our services, pricing, or availability, please fill out the form below.',
     NULL, NULL,
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-appointment.webp',
     '{}'::jsonb, 4, true);

-- Page Sections: Our Team
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('our-team', 'hero', 'hero',
     'Our Team', NULL,
     'Meet the skilled therapists and hammam attendants behind the Sultan Hamam experience.',
     NULL, NULL, NULL, '{}'::jsonb, 1, false),
    ('our-team', 'team_list', 'team',
     'Our Specialists', NULL,
     'Our core team of experienced therapists and wellness practitioners.',
     NULL, NULL, NULL,
     '{"placeholder_image":"/assets/light/wp-content/uploads/sites/4/2025/04/61-profiles-placeholder.webp","team_members":[]}'::jsonb,
     2, false);

-- Page Sections: Prices Page
INSERT INTO page_sections (page_slug, section_key, section_type, title, subtitle, description, button_text, button_url, image_url, extra_data, sort_order, visible) VALUES
    ('prices-page', 'hero', 'hero',
     'Our Prices', NULL,
     'Transparent pricing for all our Turkish bath and spa services. Swimming pool and drinks are included with all bath packages.',
     NULL, NULL, NULL, '{}'::jsonb, 1, true),
    ('prices-page', 'pricing_categories', 'pricing',
     'Service Prices', NULL,
     'All prices are per person. Swimming pool access and drinks are included with all Turkish bath packages.',
     NULL, NULL, NULL,
     '{"pricing_categories": [
        {
          "title": "Turkish Bath",
          "description": "Traditional hammam experience with sauna, steam room, and heated marble.",
          "icon_class": "cmsms-demo-icons-wellness-bliss",
          "detail_url": "/services/turkish-bath/",
          "detail_text": "View Details",
          "items": [
            {"name": "Entrance & Facility Use (Max 3 hrs)", "price": "€25"},
            {"name": "Turkish Bath - Scrub & Foam Massage (60 min)", "price": "€40"},
            {"name": "Pasha Turkish Bath - Extended (60 min)", "price": "€55"}
          ]
        },
        {
          "title": "Relaxation Massages",
          "description": "A comprehensive range of massage treatments for relaxation and well-being.",
          "icon_class": "cmsms-demo-icons-wellness-15",
          "detail_url": "/services/",
          "detail_text": "View Details",
          "items": [
            {"name": "Back, Neck & Shoulders Massage - 30 min", "price": "€30"},
            {"name": "Back, Neck, Shoulders & Legs - 45 min", "price": "€40"},
            {"name": "Swedish Full Body Massage - 60 min", "price": "€50"},
            {"name": "Aromatherapy Full Body Massage - 60 min", "price": "€55"},
            {"name": "Milk Massage Full Body - 60 min", "price": "€55"},
            {"name": "Olive Oil Massage Full Body - 60 min", "price": "€55"},
            {"name": "St. John''s Wort Oil Massage - 60 min", "price": "€55"},
            {"name": "Warm Candle Massage Full Body - 60 min", "price": "€55"},
            {"name": "Bali Massage Full Body - 60 min", "price": "€55"},
            {"name": "Hot Stone Massage Full Body - 90 min", "price": "€70"}
          ]
        },
        {
          "title": "Medical Massages",
          "description": "Therapeutic treatments targeting pain relief, recovery, and muscle rehabilitation.",
          "icon_class": "cmsms-demo-icons-wellness-11",
          "detail_url": "/services/",
          "detail_text": "View Details",
          "items": [
            {"name": "Medical Massage + Cupping (Shoulders/Back) - 30 min", "price": "€35"},
            {"name": "Medical Massage + Cupping (Full Back/Legs) - 45 min", "price": "€45"},
            {"name": "Full Body Medical Massage - 60 min", "price": "€55"},
            {"name": "Sports Massage - 60 min", "price": "€55"},
            {"name": "Deep Tissue Massage Full Body - 60 min", "price": "€55"},
            {"name": "Lymph Drainage (Detox) Full Body - 60 min", "price": "€55"}
          ]
        },
        {
          "title": "Specialty Services",
          "description": "Additional treatments and therapies.",
          "icon_class": "cmsms-demo-icons-wellness-8",
          "detail_url": "/services/",
          "detail_text": "View Details",
          "items": [
            {"name": "Indian Head Massage - 30 min", "price": "€30"},
            {"name": "Reflexology (Foot Massage) - 30 min", "price": "€30"},
            {"name": "Pregnancy Massage - 60 min", "price": "€55"},
            {"name": "Face Mask", "price": "€10"},
            {"name": "Hard Skin (Callus) Removal", "price": "€10"}
          ]
        },
        {
          "title": "Spa Packages",
          "description": "Combined Turkish bath and massage packages. All include swimming pool and drinks.",
          "icon_class": "cmsms-demo-icons-wellness-9",
          "detail_url": "/services/",
          "detail_text": "View Details",
          "items": [
            {"name": "Package 1: Bath + Back Massage 30 min", "price": "€60"},
            {"name": "Package 2: Bath + Upper/Lower Body 45 min", "price": "€70"},
            {"name": "Package 3: Bath + Swedish Full Body 60 min", "price": "€80"},
            {"name": "Silver: Bath + Full Body + Face Mask", "price": "€85"},
            {"name": "Gold: Bath + Full Body + Face Mask + Callus", "price": "€90"}
          ]
        }
     ]}'::jsonb, 2, true),
    ('prices-page', 'services_slider', 'services',
     'Our Services', NULL, NULL, NULL, NULL, NULL,
     '{"placeholder_image": "/assets/light/wp-content/uploads/sites/4/2025/04/61-open-service-placeholder.webp",
       "services": [
        {
          "title": "Turkish Bath Hammam",
          "excerpt": "Traditional purification ritual",
          "description": "A complete hammam experience: Sauna, Steam Room, exfoliating Scrub (Kese), and luxurious Foam Massage on heated marble stone.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp",
          "url": "/services/turkish-bath/",
          "button_text": "Read More",
          "categories": "turkish-bath"
        },
        {
          "title": "Swedish Massage",
          "excerpt": "Classic full body relaxation",
          "description": "A full-body massage using effleurage, petrissage, and light percussion to promote deep relaxation and improve circulation.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp",
          "url": "/services/swedish-massage/",
          "button_text": "Read More",
          "categories": "relaxation-massages"
        },
        {
          "title": "Hot Stone Massage",
          "excerpt": "Deep warmth and relaxation",
          "description": "Heated basalt stones placed on key energy points and used with flowing massage strokes for deep muscle relaxation. 90 minutes.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp",
          "url": "/services/hot-stone-massage/",
          "button_text": "Read More",
          "categories": "relaxation-massages"
        },
        {
          "title": "Deep Tissue Massage",
          "excerpt": "Targeted pain relief",
          "description": "Targets chronic muscle pain and deep-seated stiffness with focused pressure to release muscle knots and restore mobility.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp",
          "url": "/services/deep-tissue-massage/",
          "button_text": "Read More",
          "categories": "medical-massages"
        },
        {
          "title": "Aromatherapy Massage",
          "excerpt": "Essential oils for body and mind",
          "description": "A relaxing full-body massage enhanced with aromatic essential oils selected for your individual needs.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp",
          "url": "/services/aromatherapy-massage/",
          "button_text": "Read More",
          "categories": "relaxation-massages"
        },
        {
          "title": "Reflexology",
          "excerpt": "Healing through the feet",
          "description": "Specialized pressure applied to reflex points on the feet to stimulate related organs and body systems.",
          "icon_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg",
          "bg_image_url": "/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp",
          "url": "/services/reflexology/",
          "button_text": "Read More",
          "categories": "specialty-services"
        }
      ]}'::jsonb, 3, true);

-- 5. SERVICES DATA

-- Insert Services
INSERT INTO services (slug, title, category, short_description, full_description, hero_image_url, icon_url, sidebar_links, visible, sort_order) VALUES
    ('turkish-bath', 'Turkish Bath Hammam (Scrub & Foam)', 'Turkish Bath',
     'A traditional purification ritual including sauna, steam room, exfoliating scrub (kese), and foam massage on heated marble.',
     'This treatment is a purification and renewal ritual that reflects the traditional Turkish hammam experience. The guest first takes a warm shower to prepare the body. Then, time is spent in the sauna, where dry heat promotes sweating and toxin release. This is followed by the steam room, where humid heat allows deep warming of the body and supports easier breathing. The main stage of the ritual takes place on the heated marble stone, where a hammam attendant (tellak) performs a full-body exfoliating scrub (kese) to remove dead skin cells and stimulate circulation. The treatment continues with a rich and soft foam massage, during which the entire body is gently massaged and lightly stretched.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg',
     '[{"title":"Swedish Massage","url":"/services/swedish-massage/"},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"}]'::jsonb,
     true, 1),
     
    ('package-1', 'Package 1 (Bath + Back Massage)', 'Spa Packages',
     'A compact spa journey: Sauna, Steam Room, Scrub, Soap Massage and a 30-minute Back, Neck & Shoulders Massage.',
     'Our Package 1 is the perfect introduction to the hammam experience combined with targeted massage therapy. It includes full access to our sauna and steam room to open your pores and detoxify your body. This is followed by a traditional scrub and soap massage in the hammam. The experience is crowned with a 30-minute professional massage focusing on the areas where stress accumulates most: the back, neck, and shoulders. Swimming pool access and all drinks are included.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-1.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-1.svg',
     '[{"title":"Package 2","url":"/services/package-2/"},{"title":"Package 3","url":"/services/package-3/"},{"title":"Turkish Bath","url":"/services/turkish-bath/"}]'::jsonb,
     true, 2),

    ('package-2', 'Package 2 (Bath + 45min Massage)', 'Spa Packages',
     'Bath ritual plus an extended 45-minute massage covering the Back, Neck, Shoulders, and Legs.',
     'Package 2 offers a more comprehensive relaxation journey. After the initial purification in the sauna, steam room, and traditional hammam scrub and soap massage, you will receive a 45-minute massage. This treatment targets the entire muscle chain from your neck down to your feet, relieving fatigue in both the upper and lower body. Perfect for those who stand for long hours or athletes. Swimming pool access and all drinks are included.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-2.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-2.svg',
     '[{"title":"Package 1","url":"/services/package-1/"},{"title":"Package 3","url":"/services/package-3/"},{"title":"Silver Package","url":"/services/silver-package/"}]'::jsonb,
     true, 3),

    ('package-3', 'Package 3 (Bath + Full Body)', 'Spa Packages',
     'The ultimate relaxation: Bath ritual plus a full 1-hour Swedish (Classic) Full Body Massage.',
     'Our most popular choice for total renewal. Package 3 combines the deep cleansing of the Turkish bath (sauna, steam room, kese, and foam) with a complete 1-hour Swedish Full Body Massage. Every muscle group is addressed, ensuring total physical and mental relaxation. This package is ideal for regular massage clients and anyone seeking a deep, holistic experience. Swimming pool access and all drinks are included.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-3.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-3.svg',
     '[{"title":"Package 2","url":"/services/package-2/"},{"title":"Silver Package","url":"/services/silver-package/"},{"title":"Gold Package","url":"/services/gold-package/"}]'::jsonb,
     true, 4),

    ('silver-package', 'Silver Package', 'Spa Packages',
     'A complete spa experience: Bath ritual, 1-hour Full Body Massage, and a nourishing Face Mask.',
     'Elevate your visit with the Silver Package. In addition to the full Turkish bath ritual (sauna, steam room, scrub, and foam) and a 1-hour Swedish Full Body Massage, you will receive a specialized face mask (Clay, Seaweed, or Volcanic Dust) to nourish and detoxify your skin. It is a complete head-to-toe rejuvenation. Swimming pool access and all drinks are included.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-4.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-4.svg',
     '[{"title":"Package 3","url":"/services/package-3/"},{"title":"Gold Package","url":"/services/gold-package/"},{"title":"Face Mask","url":"/services/face-mask/"}]'::jsonb,
     true, 5),

    ('gold-package', 'Gold Package', 'Spa Packages',
     'The pinnacle of wellness: Silver Package plus Hard Skin Removal (Foot Callus).',
     'Our most comprehensive package for total transformation. The Gold Package covers every detail: full Turkish bath ritual, 1-hour Swedish Full Body Massage, a premium face mask, and professional hard skin/callus removal for your feet. Leave feeling completely renewed from the top of your head to the soles of your feet. Swimming pool access and all drinks are included.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-5.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-5.svg',
     '[{"title":"Silver Package","url":"/services/silver-package/"},{"title":"Hard Skin Removal","url":"/services/hard-skin-removal/"},{"title":"Swedish Massage","url":"/services/swedish-massage/"}]'::jsonb,
     true, 6),

    ('swedish-massage', 'Swedish Full Body Massage', 'Relaxation Massages',
     'A classic and effective 1-hour full-body massage incorporating traditional Swedish techniques for total relaxation.',
     'A classic and effective full-body massage incorporating all principles of traditional Swedish massage. Covers the back, legs, arms, abdomen, chest, neck, and face. Applied using effleurage (long strokes), petrissage (kneading), and light percussion techniques. It stimulates blood circulation, promotes deep muscle relaxation, and helps reduce stress levels.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg',
     '[{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Bali Massage","url":"/services/bali-massage/"},{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"}]'::jsonb,
     true, 7),

    ('aromatherapy-massage', 'Aromatherapy Massage', 'Relaxation Massages',
     'A relaxing massage performed with aromatic essential oils to enhance mental and physical calmness.',
     'A relaxing 1-hour massage performed with aromatic essential oils selected according to your preference. The combination of targeted massage techniques and soothing scents promotes deep mental relaxation and reduces stress levels. Ideal for those who prefer a gentle but deeply sensory experience.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg',
     '[{"title":"Swedish Massage","url":"/services/swedish-massage/"},{"title":"Milk Massage","url":"/services/milk-massage/"},{"title":"Bali Massage","url":"/services/bali-massage/"}]'::jsonb,
     true, 8),

    ('deep-tissue-massage', 'Deep Tissue Massage', 'Medical Massages',
     'Targets chronic muscle pain and deep-seated stiffness with focused pressure to release muscle knots.',
     'Deep Tissue Massage targets chronic muscle pain and deep-seated stiffness by focusing on the deeper layers of muscle tissue. Our therapists use slow, intense pressure to release "knots" and tension that traditional massages may miss. It is ideal for those with persistent pain, posture-related discomfort, or active lifestyles. Mild soreness for 1–2 days is normal as your body recovers.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg',
     '[{"title":"Sports Massage","url":"/services/sports-massage/"},{"title":"Hot Stone Massage","url":"/services/hot-stone-massage/"},{"title":"Swedish Massage","url":"/services/swedish-massage/"}]'::jsonb,
     true, 9),

    ('hot-stone-massage', 'Hot Stone Massage', 'Relaxation Massages',
     'A 90-minute deep relaxation massage using heated natural basalt stones to melt away tension.',
     'Experience the soothing warmth of smooth, heated volcanic basalt stones. These stones retain heat and transfer it slowly into your muscles, allowing for deeper relaxation without intense pressure. The 90-minute session includes both hand-based massage and rhythmic stone strokes, providing a uniquely grounding and calming experience.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg',
     '[{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Bali Massage","url":"/services/bali-massage/"}]'::jsonb,
     true, 10),

    ('bali-massage', 'Bali Massage', 'Relaxation Massages',
     'A full-body massage combining flowing strokes, controlled deep pressure, and gentle stretching.',
     'Bali massage is a full-body, deep-tissue, holistic treatment. It uses a combination of gentle stretches, acupressure, reflexology, and aromatherapy to stimulate the flow of blood, oxygen, and "qi" (energy) around your body. It is designed to bring a sense of well-being, calm, and deep relaxation.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-6.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-6.svg',
     '[{"title":"Swedish Massage","url":"/services/swedish-massage/"},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Hot Stone Massage","url":"/services/hot-stone-massage/"}]'::jsonb,
     true, 11),

    ('reflexology', 'Reflexology (Foot Massage)', 'Specialty Services',
     'Specialized pressure applied to reflex points on the feet to stimulate related organs and systems.',
     'Reflexology is more than a foot massage. By applying specialized pressure to specific reflex points on the soles of the feet, our therapists aim to stimulate and balance related organs and systems throughout the entire body. It is a deeply relaxing 30-minute therapy that relief foot fatigue and promotes overall vitality.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-12.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-12.svg',
     '[{"title":"Indian Head Massage","url":"/services/indian-head-massage/"},{"title":"Hard Skin Removal","url":"/services/hard-skin-removal/"},{"title":"Swedish Massage","url":"/services/swedish-massage/"}]'::jsonb,
     true, 12),

    ('shoulder-neck-back-massage', 'Shoulder, Neck & Back Massage', 'Relaxation Massages',
     'A 30-minute targeted massage focusing on areas where stress accumulates most.',
     'A massage combining Swedish and deep tissue techniques, focusing on areas where stress accumulates most. Targets tension in the trapezius muscles, neck, and shoulder blade area. Helps relieve chronic neck and back pain and improves mobility.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg',
     '[{"title":"Indian Head Massage","url":"/services/indian-head-massage/"},{"title":"Swedish Massage","url":"/services/swedish-massage/"}]'::jsonb,
     true, 13),

    ('milk-massage', 'Milk Massage', 'Relaxation Massages',
     'A luxurious spa massage using milk proteins for intensive skin care and deep relaxation.',
     'A spa massage performed with milk proteins and moisturizing ingredients. Provides both relaxation and intensive skin care throughout the session. Deeply moisturizes and softens the skin, improving texture and smoothness.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg',
     '[{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Olive Oil Massage","url":"/services/olive-oil-massage/"}]'::jsonb,
     true, 14),

    ('st-johns-wort-massage', 'St. Johns Wort Oil Massage', 'Relaxation Massages',
     'A therapeutic massage using special St. Johns Wort oil for nerve and muscle recovery.',
     'A therapeutic massage using a special reddish oil obtained from St. Johns Wort. Effective on the nervous system and deep muscle tissues, supporting skin repair and relieving neuropathic pain.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg',
     '[{"title":"Medical Massage","url":"/services/medical-massage-back/"},{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"}]'::jsonb,
     true, 15),

    ('indian-head-massage', 'Indian Head Massage', 'Relaxation Massages',
     'Traditional relaxation massage focusing on the head, neck, and shoulders.',
     'A traditional relaxation massage focusing on the head, neck, and shoulders. Applied with rhythmic and gentle pressure to reduce mental fatigue and relieve tension headaches.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg',
     '[{"title":"Reflexology","url":"/services/reflexology/"},{"title":"Shoulder, Neck & Back Massage","url":"/services/shoulder-neck-back-massage/"}]'::jsonb,
     true, 16),

    ('medical-massage-back', 'Medical Massage: Back & Neck + Cupping', 'Medical Massages',
     'Targeted medical massage with cupping for deep shoulder, neck, and back stiffness.',
     'A targeted medical massage using therapeutic cream to address muscle tension and stiffness. Optional cupping therapy can be added to support relief from intense fatigue.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg',
     '[{"title":"Medical Massage: Back & Leg","url":"/services/medical-massage-leg/"},{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"}]'::jsonb,
     true, 17),

    ('medical-massage-leg', 'Medical Massage: Back & Leg + Cupping', 'Medical Massages',
     'Comprehensive medical massage targeting lower back, hips, and legs for sciatica relief.',
     'A comprehensive medical massage targeting the lower back, hips, and legs. Highly effective for sciatica-related tension and muscle fatigue from prolonged sitting or standing.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-11.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-11.svg',
     '[{"title":"Medical Massage: Back & Neck","url":"/services/medical-massage-back/"},{"title":"Sports Massage","url":"/services/sports-massage/"}]'::jsonb,
     true, 18),

    ('sports-massage', 'Sports Massage', 'Medical Massages',
     'Designed for active guests, this massage focuses on muscle recovery and flexibility.',
     'A massage designed specifically for physically active guests, suitable for both pre- and post-training. Focuses on warming up muscles or supporting recovery and removing toxins.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-8.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-8.svg',
     '[{"title":"Deep Tissue Massage","url":"/services/deep-tissue-massage/"},{"title":"Medical Massage","url":"/services/medical-massage-leg/"}]'::jsonb,
     true, 19),

    ('lymphatic-drainage', 'Lymphatic Drainage (Detox)', 'Specialty Services',
     'A gentle, rhythmic massage to support detoxification and reduce fluid retention.',
     'A very gentle, rhythmic massage that supports lymphatic flow and reduces swelling. Uses light pumping movements to support natural detoxification and strengthen the immune system.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-7.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-7.svg',
     '[{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Reflexology","url":"/services/reflexology/"}]'::jsonb,
     true, 20),

    ('hot-candle-massage', 'Hot Candle Massage', 'Relaxation Massages',
     'Deeply relaxing massage using warm, skin-friendly cosmetic candles.',
     'A deeply relaxing massage using specially formulated warm massage candles. Melted candle oil nourishes the skin while gentle techniques relax the muscles and reduce stress.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-10.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-10.svg',
     '[{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"},{"title":"Milk Massage","url":"/services/milk-massage/"}]'::jsonb,
     true, 21),

    ('pregnancy-massage', 'Pregnancy Massage', 'Relaxation Massages',
     'Specialized care for expectant mothers to relieve back pain and leg swelling.',
     'Safe and soothing massage for expectant mothers (after 1st trimester). Uses special pillows for comfort and gentle techniques to relieve back pain and leg swelling.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-9.webp',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-9.svg',
     '[{"title":"Swedish Massage","url":"/services/swedish-massage/"},{"title":"Aromatherapy Massage","url":"/services/aromatherapy-massage/"}]'::jsonb,
     true, 22),

    ('face-mask', 'Detox Face Mask', 'Specialty Services',
     'Head-to-toe care with Clay, Seaweed, or Volcanic Dust detoxifying masks.',
     'Deep cleansing and pore tightening using natural clays or minerals. Removes excess oil, dirt, and toxins while increasing circulation for a healthy, vibrant glow.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-4.svg',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-4.svg',
     '[{"title":"Turkish Bath","url":"/services/turkish-bath/"},{"title":"Silver Package","url":"/services/silver-package/"}]'::jsonb,
     true, 23),

    ('hard-skin-removal', 'Hard Skin Removal (Foot Callus)', 'Specialty Services',
     'Professional foot care using pumice in the humid hammam for soft, smooth feet.',
     'A special treatment using natural pumice stone in the humid hammam environment to gently remove hardened skin and calluses. Your feet regain a soft and smooth texture.',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-5.svg',
     '/assets/light/wp-content/uploads/sites/4/2025/04/61-service-icon-5.svg',
     '[{"title":"Turkish Bath","url":"/services/turkish-bath/"},{"title":"Gold Package","url":"/services/gold-package/"}]'::jsonb,
     true, 24);



-- Insert Service FAQs for Turkish Bath
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    ((SELECT id FROM services WHERE slug = 'turkish-bath'), 'What should I bring for the Turkish Bath?',
     'You can bring your own swimsuit, bikini, or swim shorts. We provide pestemal (traditional towel), towels, slippers, soap, and shampoo. Feel free to bring your own personal hair products if you prefer.', 1),
    ((SELECT id FROM services WHERE slug = 'turkish-bath'), 'Is the Turkish Bath suitable for everyone?',
     'Hammam heat may not be suitable for guests with high blood pressure, heart conditions, diabetes, or during pregnancy. Please inform us of any health concerns before your session.', 2),
    ((SELECT id FROM services WHERE slug = 'turkish-bath'), 'How long does the full ritual take?',
     'The complete Turkish Bath ritual, including sauna, steam room, scrub, and foam massage, takes approximately 60 minutes.', 3);

-- Insert Service FAQs for Swedish Massage
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    ((SELECT id FROM services WHERE slug = 'swedish-massage'), 'Is Swedish massage good for beginners?',
     'Yes! Swedish massage is the foundation of relaxation therapy and is perfect for first-timers. It uses gentle to medium pressure to ease tension and promote calm.', 1),
    ((SELECT id FROM services WHERE slug = 'swedish-massage'), 'Will I feel sore after the massage?',
     'Since Swedish massage uses gentle techniques, most guests feel relaxed and refreshed. Any mild sleepiness afterward is a normal sign that your body is releasing tension.', 2);

-- Insert Service FAQs for Deep Tissue Massage
INSERT INTO service_faqs (service_id, question, answer, sort_order) VALUES
    ((SELECT id FROM services WHERE slug = 'deep-tissue-massage'), 'Is Deep Tissue massage painful?',
     'It involves intense pressure to release deep muscle knots, so you will feel a strong sensation. However, it should never be unbearably painful—please communicate with your therapist.', 1),
    ((SELECT id FROM services WHERE slug = 'deep-tissue-massage'), 'What should I do after a Deep Tissue massage?',
     'We recommend drinking plenty of water for 24-48 hours after your session to help your body process the release of muscle tension. Mild soreness for a day or two is normal.', 2);



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


-- ============================================
-- Supabase Storage: site-images bucket
-- ============================================
-- Run this in Supabase SQL Editor to create the storage bucket and policies

-- Create the bucket (public = images are publicly accessible via URL)
INSERT INTO storage.buckets (id, name, public)
VALUES ('site-images', 'site-images', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist (safe re-run)
DROP POLICY IF EXISTS "Public read access for site-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow uploads to site-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow updates in site-images" ON storage.objects;
DROP POLICY IF EXISTS "Allow deletes in site-images" ON storage.objects;

-- Allow public read access to all files in the bucket
CREATE POLICY "Public read access for site-images"
ON storage.objects FOR SELECT
USING (bucket_id = 'site-images');

-- Allow upload (insert) for anyone (anon key)
CREATE POLICY "Allow uploads to site-images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'site-images');

-- Allow update for anyone
CREATE POLICY "Allow updates in site-images"
ON storage.objects FOR UPDATE
USING (bucket_id = 'site-images');

-- Allow delete for anyone
CREATE POLICY "Allow deletes in site-images"
ON storage.objects FOR DELETE
USING (bucket_id = 'site-images');
