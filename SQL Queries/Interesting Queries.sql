-------------------------------------------------------------- Interesting Queries --------------------------------------------------------------
--Query 1: Percentage of Confirmed and Waiting Tickets:
SELECT (
        COUNT(CASE 
                WHEN TS.Confirmed = 'Yes'
                    THEN 1
                END) * 100 / COUNT(*)
        ) AS Percentage_Confirmed
    , (
        COUNT(CASE 
                WHEN TS.Waiting = 'Yes'
                    THEN 1
                END) * 100 / COUNT(*)
        ) AS Percentage_Waiting
FROM Ticket_Status TS;

-- Query 2: Trains with the Most Diverse Age Groups of Passengers:
SELECT TOP 5 T.Train_No
    , T.Train_Name
    , MIN(P.Age) AS Min_Age
    , MAX(P.Age) AS Max_Age
    , MAX(P.Age) - MIN(P.Age) AS Age_Range
FROM Train T
JOIN Ticket TI
    ON T.Train_No = TI.Train_No
JOIN Passenger P
    ON TI.Passenger_ID = P.Passenger_ID
GROUP BY T.Train_No
    , T.Train_Name
ORDER BY Age_Range DESC;

-- Query 3: Retrieve the total cost of catering services for passengers who have reservations on trains with delays:
SELECT TOP 20 P.Passenger_ID
    , SUM(CS.Cost) AS TotalCateringCost
FROM Passenger P
JOIN Reservation R
    ON P.Passenger_ID = R.Passenger_ID
JOIN Ticket T
    ON R.Ticket_NO = T.Ticket_NO
JOIN TrainDelayHistory TDH
    ON T.Train_No = TDH.Train_No
JOIN CateringService CS
    ON TDH.Train_No = CS.Train_No
GROUP BY P.Passenger_ID
ORDER BY TotalCateringCost ASC

--Query 4: Analysis of Lost and Found Complaints by Age and Gender

SELECT  P.Age,
COUNT(CASE WHEN P.Gender = 'Male' THEN 1 END) AS Number_of_Males,
COUNT(CASE WHEN P.Gender = 'Female' THEN 1 END) AS Number_of_Females,
COUNT(*) AS Total
FROM Passenger P
JOIN LostAndFound LF ON P.Passenger_ID = LF.Claimed_By_Passenger_ID
GROUP BY P.Age
ORDER BY Total DESC, P.Age;

-- Query 5: Routes with the Highest Ticket Sales:

SELECT TOP 10 S.Route_ID
    , COUNT(*) AS Number_of_Tickets_Sold
FROM Ticket T
JOIN Schedule S
    ON T.Train_No = S.Train_No
GROUP BY S.Route_ID
ORDER BY Number_of_Tickets_Sold DESC;

-- Query 6: TOP 5 Routes with the Most Train Delays including Train Names:
SELECT TOP 5 S.Route_ID
    , COUNT(*) AS Number_of_Delays
    , T.Train_Name
FROM TrainDelayHistory TD
JOIN Schedule S
    ON TD.Train_No = S.Train_No
JOIN Train T
    ON TD.Train_No = T.Train_No
GROUP BY S.Route_ID
    , T.Train_Name
ORDER BY Number_of_Delays DESC;



--Query 7: Trains with the Highest Number of Delays:
SELECT TD.Train_No, COUNT(*) AS Number_of_Delays
FROM TrainDelayHistory TD
GROUP BY TD.Train_No
ORDER BY Number_of_Delays DESC;





-- Query 8: Stations with the Highest Number of Lost and Found Complaints:

SELECT LF.Station_Name, COUNT(*) AS Number_of_Complaints
FROM LostAndFound LF
GROUP BY LF.Station_Name
ORDER BY Number_of_Complaints DESC;



-- Query 9: Satisfaction with Complaint Resolution Process:

SELECT (COUNT(CASE WHEN C.Status = 'closed' THEN 1 END) * 100 / COUNT(*)) AS Percentage_Closed, (COUNT(CASE WHEN C.Status = 'open' THEN 1 END) * 100 / COUNT(*)) AS Percentage_Open
FROM Complaints C;


-- Query 10: Passengers with Multiple Complaints:
SELECT TOP 5
P.Passenger_ID, P.First_Name, P.Last_Name, COUNT(C.Complaint_Text) AS Number_of_Complaints
FROM Passenger P
LEFT JOIN Complaints C ON P.Passenger_ID = C.Passenger_ID
GROUP BY P.Passenger_ID, P.First_Name, P.Last_Name
HAVING COUNT(C.Complaint_Text) > 1
ORDER BY Number_of_Complaints DESC;

-- Query 11: Explore Catering Services with the Most Varied Menu
SELECT TOP 5 
CS.CateringService_Name, CS.Service_Type, COUNT(DISTINCT CS.Menu_Description) AS Menu_Variety
FROM CateringService CS
GROUP BY CS.CateringService_Name, CS.Service_Type
ORDER BY Menu_Variety DESC;

---- Query 12: find the most common reason for complaints related to lost items:
SELECT LAF.Item_Description, COUNT(C.Complaint_Text) AS ComplaintCount
FROM LostAndFound LAF
LEFT JOIN Complaints C ON LAF.Claimed_By_Passenger_ID = C.Passenger_ID
GROUP BY LAF.Item_Description
ORDER BY ComplaintCount DESC;


-- Query 13: Query to Retrieve Routes with Intermediate Stations:

SELECT DISTINCT R.Route_ID, R.Source_Station, R.Destination_Station, S.Station_Name AS Intermediate_Station
FROM Route R
LEFT JOIN Route_Intermediate_Station RS ON R.Route_ID = RS.Route_ID
LEFT JOIN Station S ON RS.Station_Name = S.Station_Name
WHERE S.Station_Name IS NOT NULL;


-- Query 14:Ticket Number with Confirmed Tickets 
SELECT 
    TS.Ticket_No,
    TS.Confirmed,
    TS.Waiting
FROM 
    Ticket T
JOIN 
    Ticket_Status TS ON T.Ticket_No = TS.Ticket_No;

-- Query 15:Query to Calculate Total Revenue from Ticket Sales:

SELECT SUM(T.Ticket_Price) AS Total_Revenue
FROM Ticket T;
