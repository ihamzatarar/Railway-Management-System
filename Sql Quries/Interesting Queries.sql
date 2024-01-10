 -------------------------------------------------------------- Interesting Queries --------------------------------------------------------------


--Query 1: Percentage of Confirmed and Waiting Tickets:
SELECT
(COUNT(CASE WHEN TS.Confirmed = 'Yes' THEN 1 END) * 100 / COUNT(*)) AS Percentage_Confirmed,
(COUNT(CASE WHEN TS.Waiting = 'Yes' THEN 1 END) * 100 / COUNT(*)) AS Percentage_Waiting
FROM Ticket_Status TS;

-- Query 2: Trains with the Most Diverse Age Groups of Passengers:

SELECT TOP 5 
T.Train_No, T.Train_Name, MIN(P.Age) AS Min_Age, MAX(P.Age) AS Max_Age, MAX(P.Age) - MIN(P.Age) AS Age_Range
FROM Train T
JOIN Schedule S ON T.Train_No = S.Train_No
JOIN Ticket TI ON S.Train_No = TI.Train_No
JOIN Passenger P ON TI.Passenger_ID = P.Passenger_ID
GROUP BY T.Train_No, T.Train_Name
ORDER BY Age_Range DESC;

-- Query 3: Retrieve the total cost of catering services for passengers who have reservations on trains with delays:

SELECT P.Passenger_ID, SUM(CS.Cost) AS TotalCateringCost
FROM Passenger P
JOIN Reservation R ON P.Passenger_ID = R.Passenger_ID
JOIN Ticket T ON R.Ticket_NO = T.Ticket_NO
JOIN TrainDelayHistory TDH ON T.Train_No = TDH.Train_No
JOIN Train TR ON T.Train_No = TR.Train_No
JOIN CateringService CS ON TR.Train_No = CS.Train_No
GROUP BY P.Passenger_ID;


--Query 4: Analysis of Lost and Found Complaints by Age and Gender

SELECT TOP 10 P.Age,
COUNT(CASE WHEN P.Gender = 'Male' THEN 1 END) AS Number_of_Males,
COUNT(CASE WHEN P.Gender = 'Female' THEN 1 END) AS Number_of_Females,
COUNT(*) AS Total
FROM Passenger P
LEFT JOIN LostAndFound LF ON P.Passenger_ID = LF.Claimed_By_Passenger_ID
GROUP BY P.Age
ORDER BY Total DESC, P.Age;

-- Query 5: Routes with the Highest Ticket Sales:

SELECT TOP 10 R.Route_ID, COUNT(*) AS Number_of_Tickets_Sold
FROM Ticket T
JOIN Schedule S ON T.Train_No = S.Train_No
JOIN Route R ON S.Route_ID = R.Route_ID
GROUP BY R.Route_ID
ORDER BY Number_of_Tickets_Sold DESC;

-- Query 6: TOP 5 Routes with the Most Train Delays:

SELECT TOP 5 R.Route_ID, COUNT(*) AS Number_of_Delays
FROM TrainDelayHistory TD
JOIN Schedule S ON TD.Train_No = S.Train_No
JOIN Route R ON S.Route_ID = R.Route_ID
GROUP BY R.Route_ID
ORDER BY Number_of_Delays DESC;
