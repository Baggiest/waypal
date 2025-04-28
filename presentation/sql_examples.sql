-- SQL Examples for WayPal QR Code Management System
-- Demonstrating various SQL operations with practical use cases

-- 1. INNER JOIN
-- Find all businesses with their categories and owner information
-- Practical use: Displaying complete business profiles with category and owner details
SELECT 
    b.name as business_name,
    b.description as business_description,
    bc.name as category_name,
    u.first_name as owner_first_name,
    u.last_name as owner_last_name
FROM business b
INNER JOIN business_category bc ON b.category_id = bc.id
INNER JOIN "user" u ON b.owner_id = u.id;

-- 2. LEFT JOIN
-- Get all businesses and their QR codes (including businesses without QR codes)
-- Practical use: Inventory management of QR codes across all businesses
SELECT 
    b.name as business_name,
    qr.code as qr_code,
    qr.name as qr_name,
    qr.is_active
FROM business b
LEFT JOIN qr_code qr ON b.id = qr.business_id;

-- 3. RIGHT JOIN
-- Find all QR code scans with business information (including orphaned scans)
-- Practical use: Audit trail of all QR code scans, even if business was deleted
SELECT 
    qr.code as qr_code,
    b.name as business_name,
    qs.device_info,
    qs.location,
    qs.created_at as scan_time
FROM qr_code_scan qs
RIGHT JOIN qr_code qr ON qs.qr_code_id = qr.id
LEFT JOIN business b ON qr.business_id = b.id;

-- 4. FULL OUTER JOIN
-- Match businesses with their social media links (showing all businesses and all links)
-- Practical use: Social media presence audit
SELECT 
    b.name as business_name,
    bl.platform,
    bl.url
FROM business b
FULL OUTER JOIN business_link bl ON b.id = bl.business_id;

-- 5. CROSS JOIN
-- Generate a matrix of all possible business category combinations
-- Practical use: Analyzing potential business category combinations
SELECT 
    bc1.name as category1,
    bc2.name as category2
FROM business_category bc1
CROSS JOIN business_category bc2
WHERE bc1.id < bc2.id;

-- 6. NATURAL JOIN
-- Match QR codes with their scans based on common columns
-- Practical use: Quick analysis of QR code usage
SELECT 
    qr.code,
    qr.name,
    qs.device_info,
    qs.location
FROM qr_code qr
NATURAL JOIN qr_code_scan qs;

-- 7. SELF JOIN
-- Find businesses in the same city
-- Practical use: Competitor analysis and local business networking
SELECT 
    b1.name as business1,
    b2.name as business2,
    b1.city
FROM business b1
JOIN business b2 ON b1.city = b2.city
WHERE b1.id < b2.id;

-- 8. Multiple Joins with Aggregation
-- Get QR code scan statistics by business and device type
-- Practical use: Analytics dashboard for business owners
SELECT 
    b.name as business_name,
    qr.name as qr_name,
    qs.device_info,
    COUNT(*) as scan_count,
    MIN(qs.created_at) as first_scan,
    MAX(qs.created_at) as last_scan
FROM business b
JOIN qr_code qr ON b.id = qr.business_id
JOIN qr_code_scan qs ON qr.id = qs.qr_code_id
GROUP BY b.name, qr.name, qs.device_info
ORDER BY scan_count DESC;

-- 9. Subquery with JOIN
-- Find businesses with above-average QR code scan counts
-- Practical use: Identifying high-performing QR code locations
SELECT 
    b.name as business_name,
    COUNT(qs.id) as total_scans
FROM business b
JOIN qr_code qr ON b.id = qr.business_id
JOIN qr_code_scan qs ON qr.id = qs.qr_code_id
GROUP BY b.id, b.name
HAVING COUNT(qs.id) > (
    SELECT AVG(scan_count)
    FROM (
        SELECT COUNT(*) as scan_count
        FROM qr_code_scan
        GROUP BY qr_code_id
    ) as scan_stats
);

-- 10. Complex JOIN with Window Functions
-- Rank QR codes by scan count within each business
-- Practical use: Performance analysis of QR code placement
SELECT 
    b.name as business_name,
    qr.name as qr_name,
    COUNT(qs.id) as scan_count,
    RANK() OVER (PARTITION BY b.id ORDER BY COUNT(qs.id) DESC) as rank_in_business
FROM business b
JOIN qr_code qr ON b.id = qr.business_id
LEFT JOIN qr_code_scan qs ON qr.id = qs.qr_code_id
GROUP BY b.id, b.name, qr.id, qr.name
ORDER BY b.name, scan_count DESC;

-- 11. OUTER JOIN with COALESCE
-- Find all businesses and their QR code scan counts, including businesses with no scans
-- Practical use: Identifying businesses with low QR code engagement
SELECT 
    b.name as business_name,
    COALESCE(COUNT(qs.id), 0) as total_scans,
    CASE 
        WHEN COUNT(qs.id) = 0 THEN 'No scans'
        WHEN COUNT(qs.id) < 5 THEN 'Low engagement'
        ELSE 'Good engagement'
    END as engagement_level
FROM business b
LEFT JOIN qr_code qr ON b.id = qr.business_id
LEFT JOIN qr_code_scan qs ON qr.id = qs.qr_code_id
GROUP BY b.id, b.name
ORDER BY total_scans;

-- 12. Division Operation (using NOT EXISTS)
-- Find businesses that have QR codes for ALL locations (entrance, reception, dining area)
-- Practical use: Identifying businesses with complete QR code coverage
SELECT b.name as business_name
FROM business b
WHERE NOT EXISTS (
    -- Find locations that this business doesn't have QR codes for
    SELECT l.location_name
    FROM (
        SELECT 'main entrance' as location_name
        UNION SELECT 'reception'
        UNION SELECT 'dining area'
        UNION SELECT 'conference room'
    ) l
    WHERE NOT EXISTS (
        -- Check if business has a QR code for this location
        SELECT 1
        FROM qr_code qr
        WHERE qr.business_id = b.id
        AND qr.metadata::json->>'location' = l.location_name
    )
);

-- 13. Division Operation (using COUNT)
-- Find businesses that have QR codes for at least 3 different locations
-- Practical use: Identifying businesses with good QR code coverage
SELECT 
    b.name as business_name,
    COUNT(DISTINCT qr.metadata::json->>'location') as location_count
FROM business b
JOIN qr_code qr ON b.id = qr.business_id
GROUP BY b.id, b.name
HAVING COUNT(DISTINCT qr.metadata::json->>'location') >= 3;

-- 14. OUTER JOIN with Conditional Aggregation
-- Analyze QR code scan patterns by time of day
-- Practical use: Optimizing QR code placement based on peak usage times
SELECT 
    b.name as business_name,
    qr.name as qr_name,
    COUNT(CASE WHEN EXTRACT(HOUR FROM qs.created_at) BETWEEN 8 AND 11 THEN 1 END) as morning_scans,
    COUNT(CASE WHEN EXTRACT(HOUR FROM qs.created_at) BETWEEN 12 AND 15 THEN 1 END) as afternoon_scans,
    COUNT(CASE WHEN EXTRACT(HOUR FROM qs.created_at) BETWEEN 16 AND 19 THEN 1 END) as evening_scans,
    COUNT(CASE WHEN EXTRACT(HOUR FROM qs.created_at) BETWEEN 20 AND 23 OR EXTRACT(HOUR FROM qs.created_at) BETWEEN 0 AND 7 THEN 1 END) as night_scans
FROM business b
LEFT JOIN qr_code qr ON b.id = qr.business_id
LEFT JOIN qr_code_scan qs ON qr.id = qs.qr_code_id
GROUP BY b.id, b.name, qr.id, qr.name
ORDER BY b.name, qr.name; 