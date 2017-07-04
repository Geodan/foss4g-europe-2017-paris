#!/bin/bash

export inputtablename=adm1
export outputtablename=adm1_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=adm1_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export inputtablename=adm2
export outputtablename=adm2_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=adm2_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export inputtablename=adm3
export outputtablename=adm3_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=adm3_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export inputtablename=adm4
export outputtablename=adm4_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=adm4_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export inputtablename=adm5
export outputtablename=adm5_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=adm5_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export inputtablename=gadm
export outputtablename=gadm_simplified1
export precision=0.0001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done

export outputtablename=gadm_simplified2
export precision=0.00001
envsubst < simplify2.sql | psql -U postgres -p 5433 research
echo table ${outputtablename} done
