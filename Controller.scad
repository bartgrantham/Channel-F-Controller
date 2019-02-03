$fn = 100;  // circle segments

/*
Next steps:
* I need a body_z (rename?)
* round the neck by the same curvature as the bottom?
*/


module body_x() {
    below = [[10,0],[10,-10],[-10,-10],[-10,0]];
    above = [[10,3/8],[10,10],[-10,10],[-10,3/8]];

    translate([-.5,3/8])
      rotate(2.28,[0,0,1])
        grip();

    mirror([1,0,0])
    translate([-.5,3/8])
      rotate(2.28,[0,0,1])
        grip();

    difference() {
        translate([0,5/8]) circle(d=1.5);
        polygon(below);
        polygon(above);
        translate([25/32,3/8]) circle(d=.375);
        translate([-25/32,3/8]) circle(d=.375);
    }

    inner = [[.5,1/4],[.625,4.5],[.5,4.75],
        [-.5,4.75],[-.625,4.5],[-.5,1/4]];
    polygon(inner);
}

module body_y() {
    r=.25;
    for(x=[1-r,-1+r], y=[r,4.75-r])
      translate([x,y])
          circle(r=r);
    inner = [[1-r,0],[1,r],[1,4.75-r],[1-r,4.75],
        [-1+r,4.75],[-1,4.75-r],[-1,r],[-1+r,0]];
    polygon(inner);
}

module body_z() {
    r = 3/16;
    hull() {
      translate([1/2,0]) 
        circle(d=1);
      translate([-1/2,0]) 
        circle(d=1);
    }
    hull() {
      for(x=[-.625+r,.625-r],y=[-.75+r,.75-r])
        translate([x,y])
        circle(r=r);
    }
}

module body1() {
    linear_extrude(height=4.75)
      hull() {
        translate([1/2,0]) 
          circle(d=1);
        translate([-1/2,0]) 
          circle(d=1);
      }
}

module body2() {
    r=1/8;
    inside2=[[1,1],[-1,1],[-1,-1],[1,-1]];
    front = [[.58,0],[.625,4.75],[-.625,4.75],[-.58,0]];
    base = [[-.625,-.75],[.625,-.75],[.625,.75],[-.625,.75]];

    intersection() {
      translate([0,.75,0])
        rotate(90,[1,0,0])
          linear_extrude(height=1.5)
            polygon(front);


     * translate([0,0,-.25])
        linear_extrude(height=5.25)
          hull()
            for(p=base+(inside2*r))
              translate(p)
                circle(r=r);
    }
/*
    edgerad = 1/4;
    side = [[.58-edgerad,0+edgerad], [.625-edgerad,4.75-edgerad],
        [-.625+edgerad,4.75-edgerad], [-.58+edgerad,0+edgerad]];

    polygon(side);

      hull()
        for(p=side)
        for(y=[-.75+edgerad,.75-edgerad])
          translate([p[0], y, p[1]]) sphere(r=edgerad);
*/
}



module grip() {
    d = 3/16;
    nubs = 21;
    bed = 1/16;
    dsq = [[0,0],[d,0],[d,d],[0,d]];
    d2=.5;

    
    for(i = [0:nubs])
      translate([0,i*d])
        circle(d=d);
    polygon([[bed,-d],[bed,(nubs+1)*d],
      [-bed,(nubs+1)*d],[-bed,-d]]);

    // bottom cap
    translate([-.5*d,-d])
      polygon(dsq);

    // top cap
    translate([(d2/2)-(d/2), (nubs+1)*d])
      circle(d=d2);
    translate([-.5*d,d*nubs])
      polygon(dsq);
}

module body() {
    intersection() {
      union() {
        body1();
        body2();
      }

      rotate(90,[1,0,0])
        translate([0,0,-1])
          linear_extrude(height=2)
            body_y();

      rotate(90,[0,1,0])
        rotate(90,[0,0,1])
          translate([0,0,-1])
            linear_extrude(height=2)
              body_x();

     translate([0,0,-.25])
        linear_extrude(height=5.5)
          body_z();
    }

 *   intersection() {
      translate([0,0,4.5])
        neck();
    }
}

module neck() {
    z_down = [[.47,0],[.64,.75],[.47,1.5],
      [-.47,1.5],[-.64,.75],[-.47,0]];
    translate([0,-.75,0])
      linear_extrude(height=.5)
        polygon(z_down);
}

scale(32,32,32) translate([0,0,-2.5]) body();
//scale(32,32,32) body2();