/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ItinId]
      ,[UserId]
      ,[StartDate]
      ,[ItinName]
  FROM [Project].[dbo].[Itinerary]

  UPDATE Itinerary
  SET UserId = '562FB55B-0AFA-46CD-A856-BF4FAB6C23D0'
  WHERE ItinId = 20;

  DELETE FROM Itinerary WHERE ItinId = 8;
