
using Printf

problemName = "uniaxialExtension"

generateBoolean   = true ;

outDir = "./output" ;

# ------------------------------------------------------------------------------
# geometria:  verificar coherencia .geo
ladoSecc = 0.05
largo    = 1

boxGrid  = [ 0.1           0.9  ;
             ladoSecc*.1   ladoSecc*.5 ;
             ladoSecc*.1   ladoSecc*.5 ]

# con este roi se asegura que solo el eje central de voxels queda en dentro
minsROI = [ 0.4,  ladoSecc*0.25,  ladoSecc*0.25 ]
maxsROI = [ 0.6,  ladoSecc*0.35,  ladoSecc*0.35 ]


voxelNums   = [ 100      ,  3        , 3        ]
# voxelNums   = [ 20      ,  3        , 3        ]' ;

pRef             = 2     # reference young modulus
nu               = 0.4
nLoadSteps       = 1
levelerror       = 0.0
plotParamsVector = [ 3 ]
tolDeltaP        = 1e-4   # converge criterion

realImagesBoolean = 0

tolDeltaP = 1e-5

# numero de parametros en los cuales se hace loop en las corridas
# numParsLoop = 3 ;

cpenal  = 1e5

#~ runsData         = cell ( numParsLoop, 1) ;

# identificacion: funcion / tension / Pini

#~ paramsVals{1} = [ 2 ]   ; paramsVals{2} = [ .1 ] ;
#~ paramsVals{3} = [ .4 ]' ; paramsVals{4} = [ 0 ]' ;

paramsVals = Vector{Vector{Float64}}(undef,4)

# intensity functions
paramsVals[1] = [ 2, 3 ]

# applied tension
paramsVals[2] = [ .1, .7 ]

# initial material parameter modulus
paramsVals[3] = [ .4, 3 ]

# error level
paramsVals[4] = [ 0 ]

# iniMet = 0; endMet = 0;  flagsPyOct = [1 1 ] ; % validacion
# iniMet = 2; endMet = 3; flagsPyOct = [] ;  % identif python
methodNums = [ 4, 5]
flagsPyOct = [] ; # identif octave

strPaper = "/home/jor/work/udelar/investigacion/papers/paper_IBHMI_repo/texs"

# --- genera tex con valores de corridas de ejemplo ---
paramsTexFile = strPaper * "/paramsTexs/" * problemName * "_Params.tex"

print(fileParams)

paramFID     = open( paramsTexFile, "w" ) ;
@printf( paramFID ,"\\def\\exUnoERef{%12.2e} \n", pRef )
@printf( paramFID ,"\\def\\exUnonu{%3.2f} \n"   , nu   )

@printf( paramFID, "\\def\\exUnoNumVoxY{%4i} \n", voxelNums[2] )
@printf( paramFID, "\\def\\exUnoNumVoxX{%4i} \n", voxelNums[1] )
@printf( paramFID, "\\def\\exUnoNumVoxZ{%4i} \n", voxelNums[3] )

@printf( paramFID, "\\def\\exUnoLength{%1.0f} \n", largo );
@printf( paramFID, "\\def\\exUnoLadoSecc{%5.2f} \n", ladoSecc );

@printf( paramFID, "\\def\\exUnoMinXROI{%5.3f} \n", minsROI[1] )
@printf( paramFID, "\\def\\exUnoMinYROI{%5.3f} \n", minsROI[2] )
@printf( paramFID, "\\def\\exUnoMinZROI{%5.3f} \n", minsROI[3] )

@printf( paramFID, "\\def\\exUnoMaxXROI{%5.3f} \n", maxsROI[1] )
@printf( paramFID, "\\def\\exUnoMaxYROI{%5.3f} \n", maxsROI[2] )
@printf( paramFID, "\\def\\exUnoMaxZROI{%5.3f} \n", maxsROI[3] )

@printf( paramFID, "\\def\\exUnoMinXFrame{%5.3f} \n", boxGrid[1,1] )
@printf( paramFID, "\\def\\exUnoMinYFrame{%5.3f} \n", boxGrid[2,1] )
@printf( paramFID, "\\def\\exUnoMinZFrame{%5.3f} \n", boxGrid[3,1] )

@printf( paramFID, "\\def\\exUnoMaxXFrame{%5.3f} \n", boxGrid[1,2] )
@printf( paramFID, "\\def\\exUnoMaxYFrame{%5.3f} \n", boxGrid[2,2] )
@printf( paramFID, "\\def\\exUnoMaxZFrame{%5.3f} \n", boxGrid[3,2] )

close( paramFID )

# run MatIPS
include("/home/jor/work/udelar/codigos/MatIPS_repo/src/MatIPS.jl")
