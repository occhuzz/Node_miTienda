const cds = require('@sap/cds')

module.exports = cds.server

cds.on('bootstrap', ()=>{console.log("Paso por bootstrap")});
cds.on('served', ()=>{console.log("Paso por served")});