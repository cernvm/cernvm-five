## cernvm-five:root
   
    docker run -it --device /dev/fuse --cap-add SYS_ADMIN -p 8888:8888 -v ~/workspace:/workspace:Z registry.cern.ch/cernvm/five/cernvm-five:root bash

    cernvm_config mount_cvmfs -s
    
    mkdir /cvmfs/sft.cern.ch
    
    mount -t cvmfs sft.cern.ch /cvmfs/sft.cern.ch 
    
    . /cvmfs/sft.cern.ch/lcg/views/LCG_100/x86_64-centos8-gcc10-opt/setup.sh
    
    root --notebook --ip="0.0.0.0" --port=8888 --no-browser --allow-root &

    bash

    cat > /png.c <<EOF
    TCanvas *c = new TCanvas;
    TH1F *h = new TH1F("gaus", "gaus", 100, -5, 5);
    h->FillRandom("gaus", 10000);
    h->Draw();
    c->Update();
    gSystem->ProcessEvents();
    TImage *img = TImage::Create();
    img->FromPad(c);
    img->WriteImage("workspace/canvas.png");
    delete h;
    delete c;
    delete img;
    EOF

    cat /png.c | root