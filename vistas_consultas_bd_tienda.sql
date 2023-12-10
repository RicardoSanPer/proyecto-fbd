-- PUNTO 10: Consultas
-- Consulta 1
SELECT Producto.nombre_producto, Producto.fabricante, Producto.precio, B.cantidad_vendida FROM Producto RIGHT JOIN
    	(SELECT Incluye.id_producto, COUNT(*) AS cantidad_vendida FROM Incluye GROUP BY Incluye.id_producto) B
ON Producto.id_producto = B.id_producto ORDER BY cantidad_vendida DESC;

-- Consulta 2
SELECT Producto.id_producto, Producto.nombre_producto, Producto.fabricante, (B.suma_cal / B.cuenta)::DECIMAL(10,2) AS promedio 
FROM Producto RIGHT JOIN
    	(SELECT id_producto, SUM(calificacion) AS suma_cal, COUNT(*) AS cuenta FROM Resena GROUP BY id_producto) B
ON Producto.id_producto = B.id_producto ORDER BY promedio DESC;


-- Consulta 3
SELECT Cliente.id_cliente, Cliente.nombre, Cliente.apellido_p, D.productos_totales  FROM Cliente RIGHT JOIN
    	(SELECT Compra.id_cliente, SUM(B.cuenta_productos) AS productos_totales  FROM Compra RIGHT JOIN
   			(SELECT Incluye.id_compra, COUNT(*) AS cuenta_productos FROM Incluye GROUP BY Incluye.id_compra) B
    	ON Compra.id_compra = B.id_compra GROUP BY Compra.id_cliente) D
ON Cliente.id_cliente = D.id_cliente ORDER BY productos_totales DESC;

-- PUNTO 11: Vistas

-- Vista 1
CREATE VIEW view_reseñas_productos AS
SELECT Cuenta.id_cliente, Cuenta.nombre_cuenta, B.id_producto, B.nombre_producto, B.calificacion,  B.contenido FROM Cuenta RIGHT JOIN
	(SELECT Resena.contenido, Resena.calificacion, Resena.nombre_cuenta, Producto.nombre_producto, Resena.id_producto
	FROM Resena JOIN Producto ON Resena.id_producto = Producto.id_producto) B
ON Cuenta.nombre_cuenta = B.nombre_cuenta;

-- VIsta 2
CREATE VIEW view_productos_y_direccion_envio AS
SELECT D.id_producto, D.id_cliente, Direccion.id_direccion, Direccion.pais, Direccion.estado, Direccion.ciudad, Direccion.direccion_1,  Direccion.direccion_2, Direccion.codigo_postal
FROM Direccion RIGHT JOIN
	(SELECT Datos_Facturacion.envia_aid_direccion, B.id_producto, Datos_Facturacion.id_cliente FROM Datos_Facturacion 
	RIGHT JOIN 
		(SELECT Incluye.id_producto, Compra.id_direccion FROM Incluye 
			LEFT JOIN Compra ON Incluye.id_compra = Compra.id_compra) B 
	ON Datos_Facturacion.id_direccion = B.id_direccion) D
ON Direccion.id_direccion = D.envia_aid_direccion;

-- Vista 3
CREATE VIEW view_cliente_productos_comprados AS
SELECT D.id_cliente, Producto.id_producto, Producto.nombre_producto, Producto.fabricante FROM Producto JOIN
	(SELECT Incluye.id_producto, B.id_cliente FROM Incluye JOIN
		(SELECT Cliente.id_cliente, Compra.id_compra FROM Compra 
		LEFT JOIN Cliente ON Compra.id_cliente = Cliente.id_cliente) B
	ON B.id_compra = Incluye.id_Compra) D
ON D.id_producto = Producto.id_producto;
