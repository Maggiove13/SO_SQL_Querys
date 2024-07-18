---------------------------------------Scripts del Challenge 

-------------------------------------Nro 1----------------------------------------------------------------------------------------
-- Selecciona las columnas DisplayName, Location y Reputation de los usuarios con mayor
-- reputación. Ordena los resultados por la columna Reputation de forma descendente y
-- presenta los resultados en una tabla mostrando solo las columnas DisplayName,
-- Location y Reputation.
SELECT TOP (200)
    DisplayName,Location,Reputation
FROM Users
ORDER BY Reputation DESC


-------------------------------------Nro 2----------------------------------------------------------------------------------------
--Selecciona la columna Title de la tabla Posts junto con el DisplayName de los usuarios
-- que lo publicaron para aquellos posts que tienen un propietario.
-- Para lograr esto une las tablas Posts y Users utilizando OwnerUserId para obtener el
-- nombre del usuario que publicó cada post. Presenta los resultados en una tabla
-- mostrando las columnas Title y DisplayName

SELECT TOP 200
    Title, DisplayName
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id 
-- or --
-- SELECT TOP 200
--     Title, DisplayName
-- FROM Posts
-- INNER JOIN Users ON Posts.OwnerUserId = Users.Id 
-- WHERE Posts.Title IS NOT NULL;

-------------------------------------Nro 3----------------------------------------------------------------------------------------
-- Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName
-- del usuario junto con el promedio de Score.
-- Para esto agrupa los posts por OwnerUserId, calcula el promedio de Score para cada
-- usuario y muestra el resultado junto con el nombre del usuario. Presenta los resultados
-- en una tabla mostrando las columnas DisplayName y el promedio de Score

SELECT TOP 200
    Users.DisplayName, AVG(Posts.Score) as Score
FROM Posts
INNER JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName, Posts.OwnerUserId
ORDER BY Score DESC;

-------------------------------------Nro 4----------------------------------------------------------------------------------------
-- Encuentra el DisplayName de los usuarios que han realizado más de 100 comentarios
-- en total.
-- Para esto utiliza una subconsulta para calcular el total de comentarios por
-- usuario y luego filtra aquellos usuarios que hayan realizado más de 100 comentarios en
-- total. Presenta los resultados en una tabla mostrando el DisplayName de los usuarios.
SELECT TOP (200)
    DisplayName
FROM Users
	WHERE 
        (SELECT COUNT(*) FROM Comments WHERE Comments.UserId = Users.Id) > 100

-------------------------------------Nro 5----------------------------------------------------------------------------------------
-- Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vacías por "Desconocido". 
-- Utiliza una consulta de actualización para cambiar las ubicaciones vacías.
-- Muestra un mensaje indicando que la actualización se realizó correctamente.

UPDATE Users
	SET Location = 'Desconocido'
	WHERE Location IS NULL OR Location = '';
---- Imprimimos un mensaje
PRINT 'La actualizacion se realizó completamente'; --El ; al final es porque le damos la instruccion a UPDATE de que termino  esa instruccion

-------------------------------------Nro 6----------------------------------------------------------------------------------------
-- Elimina todos los comentarios realizados por usuarios con menos de 100 de reputación.
-- Utiliza una consulta de eliminación para eliminar todos los comentarios realizados y
-- muestra un mensaje indicando cuántos comentarios fueron eliminados

-- Declaramos una variable que se usará para almacenar el número de comentarios eliminados.
DECLARE @DeletedCount INT; --variable de tipo entero

-- Eliminar y contar las filas afectadas
DELETE FROM Comments
    WHERE UserID 
    IN 
    (
        SELECT 
            Id
        FROM Users
            WHERE Reputation < 100
    );

-- Obtener el número de filas eliminadas
SET @DeletedCount = @@ROWCOUNT;
--@@ROWCOUNT es una función interna de SQL Server que devuelve el número de filas afectadas por la última instrucción DELETE,
--INSERT, SELECT, o UPDATE.

-- Mostrar el mensaje
PRINT 'Se eliminaron ' + CAST(@DeletedCount AS VARCHAR) + ' comentarios';
--CAST convierte un valor a otro tipo de dato indicado por ejemplo el integer de @DeleteCount se convierte a un string


-------------------------------------Nro 7----------------------------------------------------------------------------------------
-- Para cada usuario, muestra el número total de publicaciones (Posts), comentarios(Comments) y medallas (Badges) que han realizado.
-- Utiliza uniones (JOIN) para combinar la información de las tablas Posts, Comments y Badges por usuario. 
-- Presenta los resultados en una tabla mostrando el DisplayName del usuario junto con el total de publicaciones, comentarios y medallas
SELECT TOP 200
	Users.DisplayName,
    COALESCE(PostCounts.TotalPosts, 0) AS TotalPosts,
    COALESCE(CommentCounts.TotalComments, 0) AS TotalComments,
    COALESCE(BadgeCounts.TotalBadges, 0) AS TotalBadges
FROM Users

LEFT JOIN 
        (
        SELECT OwnerUserId, COUNT(*) AS TotalPosts 
        FROM Posts 
        GROUP BY OwnerUserId
        ) 
        AS PostCounts
    ON Users.Id = PostCounts.OwnerUserId

LEFT JOIN 
        (
	    SELECT UserId, COUNT(*) AS TotalComments 
        FROM Comments
        GROUP BY UserId
        ) 
        AS CommentCounts
    ON Users.Id = CommentCounts.UserId

LEFT JOIN 
        (
        SELECT UserId, COUNT(*) AS TotalBadges 
        FROM Badges 
        GROUP BY UserId
        ) 
        AS BadgeCounts
    ON Users.Id = BadgeCounts.UserId;


-------------------------------------Nro 8----------------------------------------------------------------------------------------
-- Muestra las 10 publicaciones más populares basadas en la puntuación (Score) de la
-- tabla Posts. Ordena las publicaciones por puntuación de forma descendente y
-- selecciona solo las 10 primeras. Presenta los resultados en una tabla mostrando el Title
-- de la publicación y su puntuación
SELECT TOP 10 
	Title, Score 
FROM Posts
WHERE Title IS NOT NULL
ORDER BY Score DESC

-------------------------------------Nro 9----------------------------------------------------------------------------------------
-- Muestra los 5 comentarios más recientes de la tabla Comments. 
-- Ordena los comentarios por fecha de creación de forma descendente y selecciona solo los 5 primeros.
-- Presenta los resultados en una tabla mostrando el Text del comentario y la fecha de creación

SELECT TOP 5 
    Text, CreationDAte
FROM Comments
ORDER BY CreationDate DESC