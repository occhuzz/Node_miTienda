const cds = require("@sap/cds");
const { Precios, Tiendas_Duenios, Productos } = cds.entities;

module.exports = cds.service.impl(async (srv)=>
{
    //--------------------Actualizar precios-------------------------

    srv.on('ActualizarPrecios',async (req)=>
    {
        const { ID, valor } = data;

        try
        {
            await cds.run(UPDATE(Precios).set({valor : valor}).where({ID: ID}));

            return("Precio Actualizado");
        }
        catch(err)
        {
            console.log(err);
            return("Hubo un error en la actualizacion de precio");
        }
    })

    //-----------------------------------------------------------------------------
    //Crear Dueños con Tiendas

    srv.after('CREATE','Duenios', async (data,req) =>
    {
        const { ID } = data;

        let tiendas = (req._.req.query.Tiendas);
        let tiendas_ID = tiendas.split(",");
        
        try
        {
            for (let i = 0; i < tiendas_ID.length; i++)
            {
                await cds.run(INSERT.into (Tiendas_Duenios).columns('tienda_ID', 'duenio_ID').values(tiendas_ID[i],ID));
            }
            
            return "Asignación realizada correctamente.";
        }
        catch(err)
        {
            console.log(error);
            return "Ocurrió un error al asignar las Tiendas al Dueño";
        };
    });

    //-----------------------------------------------------------------------------
    //Actualizar Stock productos

    srv.on('ActualizarStock', async (req)=>
    {
        const { ID, stock } = req.data;

        const productoNuevo = await cds.run(SELECT('stock','stock_Min','stock_Max').one.from(Productos).where({ ID: ID }));

        if(stock > 0) //Compra POST
        {
            if(productoNuevo.stock + stock > productoNuevo.stock_Max) //Si al comprar la cantidad ingresada supera el Max
            {
                insertar(productoNuevo.stock_Max - productoNuevo.stock); //Inserta productos hasta llegar al Max
                return (`Compra cancelada, exceso de stock del producto. Se compraron ${ productoNuevo.stock_Max - productoNuevo.stock } productos`);

                /*
                //No se compra por exceder el límite maximo
                return ("Compra cancelada, se excedería el stock del producto.");
                */
            }
            else
            {
                insertar(stock);
                return ("Compra efectuada correctamente");
            }
        }
        else //Venta POST
        {
            if(productoNuevo.stock + stock < productoNuevo.stock_Min) // Si al vender, el stock restante es menor al Min
            {
                if(productoNuevo.stock + stock < 0) //Si se intenta vender una cantidad mayor a la disponible en stock
                {
                    return (`Venta cancelada, sólo puede vender ${productoNuevo.stock} productos.`);
                }
                else    // Si al vender, el stock restante es menor al Min
                {
                    return (`Venta cancelada. Por favor, reponer producto. Stock restante en caso de vender: ${productoNuevo.stock + stock}`);
                }
            }
            else
            {
                insertar(stock);
                return ("Venta efectuada correctamente.");
            }
        }

        async function insertar(valor)  //Funcion de insertar stock
        {
            try
            {
                await cds.run(UPDATE(Productos).with({stock: { '+=': valor }}).where({ ID: ID}));
            }
            catch(err)
            {
                console.log(err);
                return "Ocurrió un error en la actualización de stock.";
            }
        }
    })
})