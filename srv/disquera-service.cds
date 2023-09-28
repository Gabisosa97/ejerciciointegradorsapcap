using {disquera as my} from '../db/disquera-schema';

service CatalogServiceDisquera {
    // @readonly
    entity Musicos     as select from my.Musicos;

    // entity Discos      as select from my.Discos;
    entity Discos      as
        select from my.Discos {
            banda.nombre  as banda,
            nombre        as disco,
            canciones     as numero_Canciones,
            centro.nombre as centro
        };

    entity Sesiones    as select from my.Sesiones;

    @cds.redirection.target
    entity Grabaciones as
        select from my.Discos {
            ID                                as ID,
            banda.nombre                      as banda,
            nombre                            as disco,
            banda.genero                      as genero,
            banda.musico.musico.nombre.nombre as nombreMusico,
            banda.musico.musico.apellido      as apellidoMusico,
            banda.disco.sesion.createdAt      as promocion,
        }
        group by
            banda.musico.musico
        order by
            promocion desc;

    action   deleteMusicos(ID : many Musicos:ID) returns Musicos;
    function getMusico(ID : Musicos:ID)          returns many Musicos;


}
