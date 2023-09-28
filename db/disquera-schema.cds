using {
    cuid,
    managed,
    sap
} from '@sap/cds/common';

namespace disquera;

type Nombres : {
    nombre : String(15);
};

entity Musicos : cuid {
    nombre         : Nombres;
    apellido       : String(100);
    alias          : String(100);
    horasGrabacion : Association to Sesiones;
    banda          : Composition of many MusicosBandas
                         on banda.musico = $self;
}

entity Bandas : cuid, managed {
    nombre : Nombres;
    genero : String(100);
    musico : Composition of many MusicosBandas
                 on musico.banda = $self;
    disco  : Composition of many Discos
                 on disco.banda = $self;
}

entity MusicosBandas : cuid {
    key musico : Association to many Musicos;
    key banda  : Association to many Bandas;
}

entity Discos : cuid, managed {
    nombre    : Nombres;
    banda     : Association to Bandas;
    sesion    : Association to Sesiones;
    centro    : Composition of many Centros
                    on centro.disco = $self;
    price     : Decimal(13, 3);
    canciones : Integer;

}

entity Sesiones : cuid, managed {
    horasGrabacion : Integer;
    disco          : Association to Discos;
    promo          : Boolean default false;
}

entity Centros : cuid, managed {
    nombre    : Nombres;
    direccion : String(100);
    disco     : Association to Discos;
}
