CREATE DOMAIN num_telefonico AS VARCHAR(12) CHECK(VALUE ~* '^\d{3}-\d{3}-\d{4}$');
CREATE DOMAIN dir_correo AS VARCHAR(40) CHECK (VALUE ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
CREATE DOMAIN nombre_legal AS VARCHAR(20) CHECK (VALUE ~ '^[A-Za-z ]+$');
CREATE DOMAIN nombre_usuario AS VARCHAR(20) CHECK (VALUE ~ '^[a-zA-Z0-9]+$');

CREATE TABLE Cliente
(
  id_cliente SERIAL,
  nombre nombre_legal NOT NULL,
  apellido_p nombre_legal,
  apellido_m nombre_legal,
  correo dir_correo NOT NULL,
  telefono num_telefonico,
  PRIMARY KEY (id_cliente)
);
CREATE TYPE estado_type AS ENUM('Aguascalientes',
'Baja California',
'Baja California Sur',
'Campeche',
'Chiapas',
'Chihuahua',
'Ciudad de Mexico',
'Coahuila',
'Colima',
'Durango',
'Estado de Mexico',
'Guanajuato',
'Guerrero',
'Hidalgo',
'Jalisco',
'Michoacan',
'Morelos',
'Nayarit',
'Nuevo Leon',
'Oaxaca',
'Puebla',
'Queretaro',
'Quintana Roo',
'San Luis Potosi',
'Sinaloa',
'Sonora',
'Tabasco',
'Tamaulipas',
'Tlaxcala',
'Veracruz',
'Yucatan',
'Zacatecas');

CREATE TYPE pais_type AS ENUM('Mexico');

CREATE TABLE Direccion
(
  pais pais_type NOT NULL,
  estado estado_type NOT NULL,
  ciudad VARCHAR(40) NOT NULL,
  direccion_1 VARCHAR(80) NOT NULL,
  direccion_2 VARCHAR(80),
  codigo_postal VARCHAR(20),
  id_direccion SERIAL,
  PRIMARY KEY (id_direccion)
);

CREATE TYPE categoria_type AS ENUM('Electronico','Videojuego','Coleccionable','Accesorio','Mercancia','Otro');

CREATE TABLE Producto
(
  id_producto SERIAL,
  nombre_producto VARCHAR(40) NOT NULL,
  categoria categoria_type NOT NULL,
  descripcion VARCHAR(160),
  inventario INT NOT NULL,
  precio DECIMAL(5,2) NOT NULL,
  fabricante VARCHAR(20),
  PRIMARY KEY (id_producto),
  CONSTRAINT producto_precio_valido CHECK(precio >= 0),
  CONSTRAINT producto_inventario_valido CHECK(inventario >= 0)
);

CREATE TYPE metodo_type AS ENUM('Tarjeta_Bancaria','Tarjeta_Regalo','Efectivo','Pago_Electronico');

CREATE TABLE Datos_Facturacion
(
  metodo metodo_type NOT NULL,
  id_direccion INT NOT NULL,
  envia_aid_direccion INT,
  id_cliente INT NOT NULL, 
  PRIMARY KEY (id_direccion)
);

CREATE TABLE Compra
(
  id_compra SERIAL,
  monto DECIMAL(5,2) NOT NULL,
  fecha DATE NOT NULL,
  id_cliente INT,
  id_direccion INT,
  PRIMARY KEY (id_compra),
  CONSTRAINT compra_monto_valido CHECK(monto >= 0)
);

CREATE TABLE Cupon
(
  numero_cupon VARCHAR(10),
  descuento INT,
  PRIMARY KEY (numero_cupon),
  CONSTRAINT cupon_descuento_valido CHECK(descuento > 0 AND descuento <= 100)
);

CREATE TABLE Cuenta
(
  nombre_cuenta nombre_usuario NOT NULL,
  correo dir_correo NOT NULL,
  id_cliente INT,
  PRIMARY KEY (nombre_cuenta),
  UNIQUE (correo)
);

CREATE TABLE Incluye
(
  id_compra INT NOT NULL,
  id_producto INT,
  cantidad INT NOT NULL,
  CONSTRAINT incluye_cantidad_valido CHECK(cantidad >= 0)
);

CREATE TABLE Aplica
(
  id_compra INT NOT NULL,
  numero_cupon VARCHAR(10)
);

CREATE TABLE Resena
(
  calificacion INT NOT NULL,
  contenido VARCHAR(160),
  id_producto INT NOT NULL,
  nombre_cuenta nombre_usuario NOT NULL,
  PRIMARY KEY(id_producto, nombre_cuenta),
  CONSTRAINT resena_calificacion_valido CHECK(calificacion >= 0 AND calificacion <= 5)
);


ALTER TABLE Compra
  ADD CONSTRAINT compra_fk_id_cliente
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE SET NULL ON UPDATE CASCADE,
  
  ADD CONSTRAINT compa_fk_datos_facturacion
  FOREIGN KEY (id_direccion) REFERENCES Datos_Facturacion(id_direccion) ON DELETE SET NULL ON UPDATE CASCADE;
  
ALTER TABLE Cuenta
  ADD CONSTRAINT cuenta_fk_id_cliente
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE SET NULL ON UPDATE CASCADE;
  
ALTER TABLE Incluye
  ADD CONSTRAINT incluye_fk_id_compra
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra) ON DELETE CASCADE ON UPDATE CASCADE,
  
  ADD CONSTRAINT incluye_fk_id_producto
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE SET NULL ON UPDATE CASCADE;
  
ALTER TABLE Aplica
  ADD CONSTRAINT aplica_fk_id_compra
  FOREIGN KEY (id_compra) REFERENCES Compra(id_compra) ON DELETE CASCADE ON UPDATE CASCADE,
  
  ADD CONSTRAINT aplica_fk_numero_cupon
  FOREIGN KEY (numero_cupon) REFERENCES Cupon(numero_cupon) ON DELETE SET NULL ON UPDATE CASCADE;
  
ALTER TABLE Resena
  ADD CONSTRAINT reseña_fk_id_producto
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
  
  ADD CONSTRAINT reseña_fk_nombre_usurio
  FOREIGN KEY (nombre_cuenta) REFERENCES Cuenta(nombre_cuenta) ON DELETE CASCADE ON UPDATE CASCADE;
  

ALTER TABLE Datos_Facturacion
  ADD CONSTRAINT facturacion_fk_id_direccion
  FOREIGN KEY (id_direccion) REFERENCES Direccion(id_direccion) ON UPDATE CASCADE ON DELETE CASCADE,
  
  ADD CONSTRAINT facturacion_fk_envia_aid_direccion
  FOREIGN KEY (envia_aid_direccion) REFERENCES Direccion(id_direccion) ON UPDATE CASCADE ON DELETE SET NULL,
  
  ADD CONSTRAINT facturacion_fk_id_cliente
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON UPDATE CASCADE ON DELETE CASCADE;
  

