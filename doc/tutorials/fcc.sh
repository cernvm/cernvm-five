#!/bin/bash
. /etc/cernvm/functions
cernvm_config mount_cvmfs -s
mkdir /cvmfs/fcc.cern.ch /cvmfs/sw-nightlies.hsf.org /cvmfs/sw.hsf.org
mount -t cvmfs  fcc.cern.ch /cvmfs/fcc.cern.ch
mount -t cvmfs  sw-nightlies.hsf.org /cvmfs/sw-nightlies.hsf.org
mount -t cvmfs  sw.hsf.org /cvmfs/sw.hsf.org

mkdir /tutorial && cd /tutorial 

source /cvmfs/sw-nightlies.hsf.org/key4hep/setup.sh

### whizard ### 
# TODO

### KKMCee ###
KKMCee -h
cp -rp `dirname $( which KKMCee )`/../share/KKMCee/examples/Mu.input .
KKMCee -c Mu.input
KKMCee -f Mu -e 91.2 -n 1000 -o LHE_OUT_1.LHE

### BHLUMI ###
BHLUMI -h
BHLUMI -f 0.022 -t 0.082 -x 0.001 -e 91.2 -n 10000 -o kkmu_10000.LHE

### babayaga ###
babayaga -h
babayaga -f 15. -t 165. -e 91.2 -n 10000 -o bbyg_10000.LHE

### DelphesEDM4Hep ###
wget https://raw.githubusercontent.com/HEP-FCC/FCC-config/spring2021/FCCee/Generator/Pythia8/p8_noBES_ee_ZH_ecm240.cmd
wget https://raw.githubusercontent.com/HEP-FCC/FCC-config/spring2021/FCCee/Generator/Pythia8/p8_noBES_ee_ZZ_ecm240.cmd
wget https://raw.githubusercontent.com/HEP-FCC/FCC-config/spring2021/FCCee/Generator/Pythia8/p8_noBES_ee_WW_ecm240.cmd

wget https://raw.githubusercontent.com/HEP-FCC/FCC-config/spring2021/FCCee/Delphes/card_IDEA.tcl

DelphesPythia8_EDM4HEP -h

wget https://raw.githubusercontent.com/HEP-FCC/FCC-config/spring2021/FCCee/Delphes/edm4hep_IDEA.tcl

DelphesPythia8_EDM4HEP card_IDEA.tcl edm4hep_IDEA.tcl p8_noBES_ee_ZH_ecm240.cmd p8_ee_ZH_ecm240_edm4hep.root
DelphesPythia8_EDM4HEP card_IDEA.tcl edm4hep_IDEA.tcl p8_noBES_ee_ZZ_ecm240.cmd p8_ee_ZZ_ecm240_edm4hep.root
DelphesPythia8_EDM4HEP card_IDEA.tcl edm4hep_IDEA.tcl p8_noBES_ee_WW_ecm240.cmd p8_ee_WW_ecm240_edm4hep.root

### FCCAnalyses ###
cat >> import.py << EOF
#!python
import ROOT
ROOT.gSystem.Load("libFCCAnalyses")
EOF

python ./import.py

cat >> analysis_stage1.py << EOF
#Mandatory: RDFanalysis class where the use defines the operations on the TTree
class RDFanalysis():

    #__________________________________________________________
    #Mandatory: analysers funtion to define the analysers to process, please make sure you return the last dataframe, in this example it is df2
    def analysers(df):
        df2 = (
            df
            # define an alias for muon index collection
            .Alias("Muon0", "Muon#0.index")
            # define the muon collection
            .Define("muons",  "ReconstructedParticle::get(Muon0, ReconstructedParticles)")
            #select muons on pT
            .Define("selected_muons", "ReconstructedParticle::sel_pt(10.)(muons)")
            # create branch with muon transverse momentum
            .Define("selected_muons_pt", "ReconstructedParticle::get_pt(selected_muons)")
            # create branch with muon rapidity
            .Define("selected_muons_y",  "ReconstructedParticle::get_y(selected_muons)")
            # create branch with muon total momentum
            .Define("selected_muons_p",     "ReconstructedParticle::get_p(selected_muons)")
            # create branch with muon energy
            .Define("selected_muons_e",     "ReconstructedParticle::get_e(selected_muons)")
            # find zed candidates from  di-muon resonances
            .Define("zed_leptonic",         "ReconstructedParticle::resonanceBuilder(91)(selected_muons)")
            # create branch with zed mass
            .Define("zed_leptonic_m",       "ReconstructedParticle::get_mass(zed_leptonic)")
            # create branch with zed transverse momenta
            .Define("zed_leptonic_pt",      "ReconstructedParticle::get_pt(zed_leptonic)")
            # calculate recoil of zed_leptonic
            .Define("zed_leptonic_recoil",  "ReconstructedParticle::recoilBuilder(240)(zed_leptonic)")
            # create branch with recoil mass
            .Define("zed_leptonic_recoil_m","ReconstructedParticle::get_mass(zed_leptonic_recoil)")
            # create branch with leptonic charge
            .Define("zed_leptonic_charge","ReconstructedParticle::get_charge(zed_leptonic)")
            # Filter at least one candidate
            .Filter("zed_leptonic_recoil_m.size()>0")
        )
        return df2

    #__________________________________________________________
    #Mandatory: output function, please make sure you return the branchlist as a python list
    def output():
        branchList = [
            "selected_muons_pt",
            "selected_muons_y",
            "selected_muons_p",
            "selected_muons_e",
            "zed_leptonic_pt",
            "zed_leptonic_m",
            "zed_leptonic_charge",
            "zed_leptonic_recoil_m"
        ]
        return branchList
EOF

export TESTSAMPLEDIR=https://fccsw.web.cern.ch/testsamples/tutorial/
fccanalysis run analysis_stage1.py --output p8_ee_ZH_ecm240.root --files-list $TESTSAMPLEDIR/p8_ee_ZH_ecm240_edm4hep.root
fccanalysis run analysis_stage1.py --output p8_ee_ZZ_ecm240.root --files-list $TESTSAMPLEDIR/p8_ee_ZZ_ecm240_edm4hep.root
fccanalysis run analysis_stage1.py --output p8_ee_WW_ecm240.root --files-list $TESTSAMPLEDIR/p8_ee_WW_ecm240_edm4hep.root

cat >> analysis_stage2.py << EOF
processList = {
    'p8_ee_ZZ_ecm240':{},
    'p8_ee_WW_ecm240':{},
    'p8_ee_ZH_ecm240':{}
}

inputDir    = ""
outputDir   = "stage2"

#USER DEFINED CODE
import ROOT
ROOT.gInterpreter.Declare("""
bool myFilter(ROOT::VecOps::RVec<float> mass) {
    for (size_t i = 0; i < mass.size(); ++i) {
        if (mass.at(i)>80. && mass.at(i)<100.)
            return true;
    }
    return false;
}
""")
#END USER DEFINED CODE

#Mandatory: RDFanalysis class where the use defines the operations on the TTree
class RDFanalysis():

    #__________________________________________________________
    #Mandatory: analysers funtion to define the analysers to process, please make sure you return the last dataframe, in this example it is df2
    def analysers(df):
        df2 = (df
               #Filter to have exactly one Z candidate
               .Filter("zed_leptonic_m.size() == 1")
               #Define Z candidate mass
               .Define("Zcand_m","zed_leptonic_m[0]")
               #Define Z candidate recoil mass
               .Define("Zcand_recoil_m","zed_leptonic_recoil_m[0]")
               #Define Z candidate pt
               .Define("Zcand_pt","zed_leptonic_pt[0]")
               #Define Z candidate charge
               .Define("Zcand_q","zed_leptonic_charge[0]")
               #Define new var rdf entry (example)
               .Define("entry", "rdfentry_")
               #Define a weight based on entry (inline example of possible operations)
               .Define("weight", "return 1./(entry+1)")
               #Define a variable based on a custom filter
               .Define("MyFilter", "myFilter(zed_leptonic_m)")
               )
        return df2

    #__________________________________________________________
    #Mandatory: output function, please make sure you return the branchlist as a python list.
    def output():
        branchList = [
            "Zcand_m", "Zcand_pt", "Zcand_q","MyFilter","Zcand_recoil_m",
            "entry","weight"
        ]
        return branchList
EOF
fccanalysis run analysis_stage2.py

cat >> analysis_final.py << EOF
#Input directory where the files produced at the pre-selection level are
inputDir  = "stage2"

#Input directory where the files produced at the pre-selection level are
outputDir  = "final"

processList = {
    'p8_ee_ZZ_ecm240':{},
    'p8_ee_WW_ecm240':{},
    'p8_ee_ZH_ecm240':{}
}

#Link to the dictonary that contains all the cross section informations etc...
procDict = "https://fcc-physics-events.web.cern.ch/fcc-physics-events/sharedFiles/FCCee_procDict_spring2021_IDEA.json"

#produces ROOT TTrees, default is False
doTree = True

###Dictionnay of the list of cuts. The key is the name of the selection that will be added to the output file
cutList = {"sel0":"Zcand_q == 0",
           "sel1":"Zcand_q == -1 || Zcand_q == 1",
           "sel2":"Zcand_m > 80 && Zcand_m < 100",
           "sel3":"MyFilter==true && (Zcand_m < 80 || Zcand_m > 100)"
            }


#Dictionary for the ouput variable/hitograms. The key is the name of the variable in the output files. "name" is the name of the variable in the input file, "title" is the x-axis label of the histogram, "bin" the number of bins of the histogram, "xmin" the minimum x-axis value and "xmax" the maximum x-axis value.
histoList = {
    "mz":{"name":"Zcand_m","title":"m_{Z} [GeV]","bin":125,"xmin":0,"xmax":250},
    "mz_zoom":{"name":"Zcand_m","title":"m_{Z} [GeV]","bin":40,"xmin":80,"xmax":100},
    "leptonic_recoil_m":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":100,"xmin":0,"xmax":200},
    "leptonic_recoil_m_zoom":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":200,"xmin":80,"xmax":160},
    "leptonic_recoil_m_zoom1":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":100,"xmin":120,"xmax":140},
    "leptonic_recoil_m_zoom2":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":200,"xmin":120,"xmax":140},
    "leptonic_recoil_m_zoom3":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":400,"xmin":120,"xmax":140},
    "leptonic_recoil_m_zoom4":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":800,"xmin":120,"xmax":140},
    "leptonic_recoil_m_zoom5":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":2000,"xmin":120,"xmax":140},
    "leptonic_recoil_m_zoom6":{"name":"Zcand_recoil_m","title":"Z leptonic recoil [GeV]","bin":100,"xmin":130.3,"xmax":132.5},
}
EOF
fccanalysis final analysis_final.py


cat >> analysis_plots.py << EOF
import ROOT

# global parameters
intLumi        = 5.0e+06 #in pb-1
ana_tex        = 'e^{+}e^{-} #rightarrow ZH #rightarrow #mu^{+}#mu^{-} + X'
delphesVersion = '3.4.2'
energy         = 240.0
collider       = 'FCC-ee'
inputDir       = 'final'
formats        = ['png','pdf']
yaxis          = ['lin','log']
stacksig       = ['stack','nostack']
outdir         = 'plots/'

variables = ['mz','mz_zoom','leptonic_recoil_m','leptonic_recoil_m_zoom']

###Dictionary with the analysis name as a key, and the list of selections to be plotted for this analysis. The name of the selections should be the same than in the final selection
selections = {}
selections['ZH']   = ["sel0","sel1","sel2","sel3"]
selections['ZH_2'] = ["sel0","sel1"]

extralabel = {}
extralabel['sel0'] = "Selection: N_{Z} = 1"
extralabel['sel1'] = "Selection: N_{Z} = 1; 80 GeV < m_{Z} < 100 GeV"

colors = {}
colors['ZH'] = ROOT.kRed
colors['WW'] = ROOT.kBlue+1
colors['ZZ'] = ROOT.kGreen+2
colors['VV'] = ROOT.kGreen+3

plots = {}
plots['ZH'] = {'signal':{'ZH':['p8_ee_ZH_ecm240']},
               'backgrounds':{'WW':['p8_ee_WW_ecm240'],
                              'ZZ':['p8_ee_ZZ_ecm240']}
           }


plots['ZH_2'] = {'signal':{'ZH':['p8_ee_ZH_ecm240']},
                 'backgrounds':{'VV':['p8_ee_WW_ecm240','p8_ee_ZZ_ecm240']}
             }

legend = {}
legend['ZH'] = 'ZH'
legend['WW'] = 'WW'
legend['ZZ'] = 'ZZ'
legend['VV'] = 'VV boson'
EOF
fccanalysis plots analysis_plots.py

### time docker run  -it -v /home/jeberhardt/tmp/fcc.sh:/workspace/fcc.sh:ro --device /dev/fuse --cap-add SYS_ADMIN 66fa03b20d55  bash /workspace/fcc.sh