using { cuid } from '@sap/cds/common';
namespace miTienda;

entity Tiendas: cuid  //Many-to-Many Dueños _ Many-to-Many Productos
{
  sucursal            : String(100);
  fechaInauguracion   : Date;
  comentario          : String(100);
  duenio              : Association to many Tiendas_Duenios on duenio.tienda =$self;
  producto            : Association to many Tiendas_Productos on producto.tienda =$self;
}

entity Duenios : cuid //Many-to-Many Tiendas
{
  nombre  : String(100);
  edad    : Integer;
  tienda  : Association to many Tiendas_Duenios on tienda.duenio =$self;
}

entity Productos: cuid  //Many-to-Many Tiendas _ Uno-a-Uno Precios
{
  nombre    : String(100);
  stock     : Integer;
  stock_Min : Integer;
  stock_Max : Integer;
  marca     : Association to Marcas;
  subtipo   : Association to Subtipos;
  precio    : Association to Precios;
  tienda    : Association to many Tiendas_Productos on tienda.producto =$self;
}

entity Precios
{
  key ID    : Integer;
  valor     : Decimal(10,3);
  producto  : Association to many Productos on producto.precio =$self;
}

entity Marcas : cuid
{
  valor : String(100);
  producto : Association to many Productos on producto.marca =$self;
}

entity Tipos
{
  key ID : Integer;
  valor : String(100);
  subtipo : Association to many Subtipos on subtipo.tipo = $self;
}

entity Subtipos
{
  key ID : Integer;
  valor : String(100);
  tipo : Association to Tipos;
}

entity Tiendas_Duenios : cuid
{
  key tienda  : Association to Tiendas;
  key duenio  : Association to Duenios;
}

entity Tiendas_Productos : cuid
{
  key tienda  : Association to Tiendas;
  key producto  : Association to Productos;
}