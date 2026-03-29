-- =====================================================
-- Uber Ride Analysis - SQL Queries
-- Objective: Analyze booking trends, cancellations, and driver performance
-- =====================================================


-- 1. Total number of rides in each city
-- Insight: Identify high-demand cities
SELECT city, COUNT(*) AS total_rides
FROM rides
GROUP BY city;


-- 2. Cancellation rate by city
-- Insight: Detect cities with high cancellation issues
SELECT city,
       COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 1.0 / COUNT(*) AS cancellation_rate
FROM rides
GROUP BY city;


-- 3. Total rides completed by each driver
-- Insight: Evaluate driver activity/performance
SELECT driver_id, COUNT(*) AS total_rides
FROM rides
GROUP BY driver_id;


-- 4. Total completed rides per driver
-- Insight: Identify top-performing drivers
SELECT driver_id,
       COUNT(*) AS completed_rides
FROM rides
WHERE status = 'completed'
GROUP BY driver_id;


-- 5. Drivers with no rides
-- Insight: Identify inactive drivers
SELECT d.driver_id, d.driver_name
FROM drivers d
LEFT JOIN rides r 
ON d.driver_id = r.driver_id
WHERE r.driver_id IS NULL;


-- 6. Rides where driver does not exist in driver table
-- Insight: Detect data inconsistencies
SELECT r.ride_id, r.driver_id, r.city
FROM rides r
LEFT JOIN drivers d
ON r.driver_id = d.driver_id
WHERE d.driver_id IS NULL;


-- 7. Latest ride for each driver
-- Insight: Track most recent driver activity
SELECT driver_id, ride_id, city, status
FROM (
    SELECT driver_id, ride_id, city, status,
           ROW_NUMBER() OVER (PARTITION BY driver_id ORDER BY ride_id DESC) AS rn
    FROM rides
) t
WHERE rn = 1;


-- 8. Number of rides per driver (including drivers with zero rides)
-- Insight: Complete driver utilization view
SELECT d.driver_id,
       d.driver_name,
       COUNT(r.ride_id) AS total_rides
FROM drivers d
LEFT JOIN rides r
ON d.driver_id = r.driver_id
GROUP BY d.driver_id, d.driver_name;


-- 9. Drivers with more than 1 completed ride
-- Insight: Identify consistently active drivers
SELECT driver_id,
       COUNT(*) AS total_completed
FROM rides
WHERE status = 'completed'
GROUP BY driver_id
HAVING COUNT(*) > 1;


-- 10. City-wise completed rides
-- Insight: Compare successful ride distribution across cities
SELECT city,
       COUNT(*) AS completed_rides
FROM rides
WHERE status = 'completed'
GROUP BY city;
