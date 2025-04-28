-- Mock Data for WayPal QR Code Management System

-- Users
INSERT INTO "user" (id, email, password_hash, first_name, last_name, phone, created_at, updated_at)
VALUES 
    ('1', 'john@example.com', '$2b$10$abcdefghijklmnopqrstuv', 'John', 'Doe', '123-456-7890', NOW(), NOW()),
    ('2', 'jane@example.com', '$2b$10$abcdefghijklmnopqrstuv', 'Jane', 'Smith', '987-654-3210', NOW(), NOW()),
    ('3', 'bob@example.com', '$2b$10$abcdefghijklmnopqrstuv', 'Bob', 'Johnson', '555-555-5555', NOW(), NOW());

-- Business Categories
INSERT INTO business_category (id, name, description, created_at, updated_at)
VALUES 
    ('1', 'Restaurant', 'Food and dining establishments', NOW(), NOW()),
    ('2', 'Retail', 'Retail stores and shops', NOW(), NOW()),
    ('3', 'Technology', 'Tech companies and services', NOW(), NOW()),
    ('4', 'Healthcare', 'Medical and health services', NOW(), NOW());

-- Businesses
INSERT INTO business (id, name, description, address, city, state, country, postal_code, latitude, longitude, phone, email, website, category_id, owner_id, created_at, updated_at)
VALUES 
    ('1', 'Tech Solutions Inc', 'IT consulting and services', '123 Tech St', 'San Francisco', 'CA', 'USA', '94105', 37.7749, -122.4194, '415-555-0123', 'contact@techsolutions.com', 'www.techsolutions.com', '3', '1', NOW(), NOW()),
    ('2', 'Healthy Living Clinic', 'Medical and wellness center', '456 Health Ave', 'New York', 'NY', 'USA', '10001', 40.7128, -74.0060, '212-555-0456', 'info@healthyliving.com', 'www.healthyliving.com', '4', '2', NOW(), NOW()),
    ('3', 'Gourmet Delights', 'Fine dining restaurant', '789 Food Blvd', 'Chicago', 'IL', 'USA', '60601', 41.8781, -87.6298, '312-555-0789', 'reservations@gourmetdelights.com', 'www.gourmetdelights.com', '1', '3', NOW(), NOW());
    -- Same city as Tech Solutions (San Francisco)
    ('4', 'Bay Area Software', 'Software development company', '456 Coding Lane', 'San Francisco', 'CA', 'USA', '94107', 37.7790, -122.4100, '415-555-1234', 'info@bayareasoftware.com', 'www.bayareasoftware.com', '3', '4', NOW(), NOW()),
    ('5', 'SF Data Analytics', 'Data science and analytics consultancy', '789 Data Drive', 'San Francisco', 'CA', 'USA', '94110', 37.7820, -122.4090, '415-555-2345', 'contact@sfdataanalytics.com', 'www.sfdataanalytics.com', '3', '1', NOW(), NOW()),    
    -- Same category as Gourmet Delights (category_id 1 - Restaurants)
    ('6', 'Pasta Paradise', 'Italian pasta restaurant', '123 Noodle St', 'Los Angeles', 'CA', 'USA', '90001', 34.0522, -118.2437, '213-555-3456', 'info@pastaparadise.com', 'www.pastaparadise.com', '1', '5', NOW(), NOW()),
    ('7', 'Sushi Supreme', 'Premium sushi restaurant', '456 Fish Ave', 'Seattle', 'WA', 'USA', '98101', 47.6062, -122.3321, '206-555-4567', 'contact@sushisupreme.com', 'www.sushisupreme.com', '1', '6', NOW(), NOW()),    
    -- Same owner as Tech Solutions (owner_id 1)
    ('8', 'Cloud Computing Experts', 'Cloud infrastructure services', '321 Cloud St', 'Austin', 'TX', 'USA', '78701', 30.2672, -97.7431, '512-555-5678', 'help@cloudcomputing.com', 'www.cloudcomputing.com', '3', '1', NOW(), NOW()),
    -- Same category as Healthy Living (category_id 4 - Healthcare)
    ('9', 'Wellness Center', 'Holistic health and wellness', '654 Zen Rd', 'Denver', 'CO', 'USA', '80202', 39.7392, -104.9903, '303-555-6789', 'info@wellnesscenter.com', 'www.wellnesscenter.com', '4', '7', NOW(), NOW()),
    ('10', 'Family Medicine Associates', 'Primary care medical clinic', '987 Health Pkwy', 'New York', 'NY', 'USA', '10002', 40.7150, -74.0080, '212-555-7890', 'appointments@familymedicine.com', 'www.familymedicine.com', '4', '2', NOW(), NOW()),    
    -- New category (category_id 5 - Retail)
    ('11', 'Fashion Forward', 'Trendy clothing boutique', '123 Style St', 'Miami', 'FL', 'USA', '33101', 25.7617, -80.1918, '305-555-8901', 'shop@fashionforward.com', 'www.fashionforward.com', '5', '8', NOW(), NOW()),
    ('12', 'Tech Gadgets', 'Electronics and gadget store', '456 Gadget Way', 'San Francisco', 'CA', 'USA', '94108', 37.7880, -122.4080, '415-555-9012', 'sales@techgadgets.com', 'www.techgadgets.com', '5', '9', NOW(), NOW()),
    
-- Business Links
INSERT INTO business_link (id, business_id, platform, url, created_at, updated_at)
VALUES 
    ('1', '1', 'facebook', 'https://facebook.com/techsolutions', NOW(), NOW()),
    ('2', '1', 'twitter', 'https://twitter.com/techsolutions', NOW(), NOW()),
    ('3', '2', 'instagram', 'https://instagram.com/healthyliving', NOW(), NOW()),
    ('4', '3', 'facebook', 'https://facebook.com/gourmetdelights', NOW(), NOW());

-- QR Codes
INSERT INTO qr_code (id, code, name, description, business_id, owner_id, is_active, metadata, created_at, updated_at)
VALUES 
    ('1', 'QR_TECH_001', 'Main Entrance', 'Main entrance QR code', '1', '1', true, '{"location": "main entrance", "floor": "1"}', NOW(), NOW()),
    ('2', 'QR_TECH_002', 'Conference Room', 'Conference room QR code', '1', '1', true, '{"location": "conference room", "floor": "2"}', NOW(), NOW()),
    ('3', 'QR_HEALTH_001', 'Reception', 'Reception area QR code', '2', '2', true, '{"location": "reception", "floor": "1"}', NOW(), NOW()),
    ('4', 'QR_REST_001', 'Menu', 'Restaurant menu QR code', '3', '3', true, '{"location": "dining area", "floor": "1"}', NOW(), NOW());

-- QR Code Scans
INSERT INTO qr_code_scan (id, qr_code_id, device_info, location, referrer, metadata, created_at)
VALUES 
    ('1', '1', 'iPhone 12', 'Main Entrance', 'direct', '{"browser": "Safari", "os": "iOS 15"}', NOW() - INTERVAL '2 days'),
    ('2', '1', 'Samsung Galaxy S21', 'Main Entrance', 'direct', '{"browser": "Chrome", "os": "Android 12"}', NOW() - INTERVAL '1 day'),
    ('3', '2', 'iPad Pro', 'Conference Room', 'direct', '{"browser": "Safari", "os": "iOS 15"}', NOW() - INTERVAL '12 hours'),
    ('4', '3', 'iPhone 13', 'Reception', 'direct', '{"browser": "Safari", "os": "iOS 15"}', NOW() - INTERVAL '6 hours'),
    ('5', '4', 'Google Pixel 6', 'Dining Area', 'direct', '{"browser": "Chrome", "os": "Android 12"}', NOW() - INTERVAL '3 hours'); 