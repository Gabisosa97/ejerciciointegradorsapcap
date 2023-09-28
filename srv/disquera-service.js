const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {
  const { Musicos, Sesiones, Centros } = this.entities;

  this.before(
    "CREATE",
    Sesiones,
    async (req) => {
      const { horasGrabacion } = req.data;

      try {
        if (horasGrabacion >= 6) {
          req.data.promo = true;
          req.data.horasGrabacion += 2;
        }
      } catch (e) {
        req.reject(400, e);
      }
    },

    this.before("UPDATE", Sesiones, async (req) => {
      const { ID, horasGrabacion } = req.data;
      try {
        const query = await SELECT.from(Sesiones, { ID });
        if (query) {
          if (horasGrabacion >= 6 && query.promo === false) {
            req.data.promo = true;
            req.data.horasGrabacion = horasGrabacion + 2;
          } else if (horasGrabacion < 6 && query.promo === false) {
            req.data.promo = true;
            req.data.horasGrabacion = horasGrabacion - 2;
          }
        }
      } catch (e) {
        req.reject(400, e);
      }
    }),

    this.on("deleteMusicos", async (req) => {
      const { ID } = req.data;
      console.log(ID);
      try {
        const musicos = await SELECT.from(Musicos)
          .columns("nombre_nombre", "apellido")
          .where({ ID });
        await DELETE.from(Musicos, { ID });

        musicos.forEach((m) => {
          console.log(`Musico eliminado: ${m.nombre_nombre} ${m.apellido}`);
        });
        return musicos;
      } catch (e) {
        req.reject(400, e);
      }
    }),
    this.on("getMusico", async (req) => {
      const { ID } = req.data;
      console.log(ID);
      try {
        const musico = await SELECT.from(Musicos).where({ ID });

        return musico;
      } catch (e) {
        req.reject(400, e);
      }
    })
  );
});
