-- Gender Category vs Video Views

SELECT Creator_Gender, AVG(Video_Views) AS AvgVideoViews
FROM [dbo].[Youtube Influencer Analysis]
GROUP BY Creator_Gender;


-- Language of the Video vs Video Views

SELECT Language_Of_the_Video, AVG(Video_Views) AS AvgVideoViews
FROM [dbo].[Youtube Influencer Analysis]
WHERE Language_Of_the_Video IN ('English', 'Hindi', 'Malayalam')
GROUP BY Language_Of_the_Video;


-- Maximum Quality of the Video vs Video Views

SELECT Maximum_Quality_Of_the_Video, AVG(Video_Views) AS AvgVideoViews
FROM [dbo].[Youtube Influencer Analysis]
GROUP BY Maximum_Quality_Of_the_Video;


-- Premiered or Not vs Video Views

SELECT Premiered_or_Not, AVG(Video_Views) AS AvgVideoViews
FROM [dbo].[Youtube Influencer Analysis]
GROUP BY Premiered_or_Not;












