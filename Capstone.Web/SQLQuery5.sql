/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [ItinId]
      ,[PlaceId]
      ,[Order]
      ,[Name]
      ,[Address]
      ,[Latitude]
      ,[Longitude]
      ,[Category]
  FROM [Project].[dbo].[Itinerary_Stops]

  DELETE FROM Itinerary_Stops WHERE ItinId = 15;

  DELETE FROM Itinerary WHERE ItinId = 15;

