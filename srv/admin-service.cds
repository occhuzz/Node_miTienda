using { miTienda as my } from '../db/schema';

service ApiService @(_requires:'authenticated-user')
{
  entity Tiendas as projection on my.Tiendas;
  entity Duenios as projection on my.Duenios;
  entity Precios as projection on my.Precios;
  entity Productos as projection on my.Productos;
  entity Marcas as projection on my.Marcas;
  entity Tipos as projection on my.Tipos;
  entity Subtipos as projection on my.Subtipos;

  entity Tiendas_Duenios as SELECT from my.Tiendas_Duenios
  {*,
    Tiendas_Duenios.ID,
    tienda.sucursal as tienda_Sucursal,
    duenio.nombre as duenio_Nombre,
  };

  entity Tiendas_Productos as SELECT from my.Tiendas_Productos
  {*,
    Tiendas_Productos.ID,
    tienda.sucursal as tienda_Sucursal,
    producto.nombre as producto_Nombre,
  };

  entity Vista_Tienda as SELECT from Tiendas
  {
    sucursal as nombre_Sucursal,
    producto.producto.nombre as producto_Nombre,
    producto.producto.precio.valor as producto_Precio,
    duenio.duenio.nombre as duenio_Nombre,
  };

  entity Vista_Producto as SELECT from Productos
  {
    nombre,
    marca,
    precio.valor,
    subtipo.tipo.valor as tipoProducto,
    subtipo.valor as subtipoProducto,
  } where subtipo.tipo.valor = 'Muebles' ;

  entity Vista_Precio as SELECT from Productos
  {
    nombre,
    marca,
    precio.valor,
    subtipo.tipo.valor as tipoProducto,
    subtipo.valor as subtipoProducto,
  } where precio.valor > 50 and precio.valor < 1500 ;

  action ActualizarPrecios(precio : Precios) returns String;
  action DuenioURL(duenio : Duenios) returns String;
  action ActualizarStock(ID : Productos : ID, stock : Productos :stock) returns String;
}