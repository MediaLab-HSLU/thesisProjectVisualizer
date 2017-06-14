#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    ofSetOrientation(OF_ORIENTATION_DEFAULT);
    
    touchPoint.x = touchPoint.y = -1;
    
    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->addTarget("CA markers", "cameraArts.xml"); //need to add dat and xml files to OF projects
    
    qcar->autoFocusOn();
    qcar->setCameraPixelsFlag(true);
    qcar->setup();

    
    //load thesis images::::::::::::::::::::::::::::::::::::::::::::::::::::
    thesis.resize(10);
    thesis[0].loadImage("thesis/thesis_0.png");
    thesis[1].loadImage("thesis/thesis_1.png");
    thesis[2].loadImage("thesis/thesis_2.png");
    thesis[3].loadImage("thesis/thesis_3.png");
    thesis[4].loadImage("thesis/thesis_4.png");
    thesis[5].loadImage("thesis/thesis_5.png");
    thesis[6].loadImage("thesis/thesis_6.png");
    thesis[7].loadImage("thesis/thesis_7.png");
    thesis[8].loadImage("thesis/thesis_8.png");
    thesis[9].loadImage("thesis/thesis_9.png");
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
}

//--------------------------------------------------------------
void ofApp::update(){
    ofxQCAR::getInstance()->update();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofxQCAR * qcar = ofxQCAR::getInstance();
    qcar->draw();
    
    bool bPressed;
    bPressed = touchPoint.x >= 0 && touchPoint.y >= 0;
    
    if(qcar->hasFoundMarker()) {
        qcar->getMarkerName();
        cout<<qcar->getMarkerName()<<endl;
        
        ofDisableDepthTest();
        ofEnableBlendMode(OF_BLENDMODE_ALPHA);
        ofSetLineWidth(3);
        
        
        bool bInside = false;
        if(bPressed) {
            vector<ofPoint> markerPoly;
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)0));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)1));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)2));
            markerPoly.push_back(qcar->getMarkerCorner((ofxQCAR_MarkerCorner)3));
            bInside = ofInsidePoly(touchPoint, markerPoly);
            
        }
        
        ofSetColor(ofColor(100, 20, 200, bInside ? 150 : 50));
        //qcar->drawMarkerRect();
        //qcar->drawMarkerBounds();
        //ofSetColor(ofColor::cyan);
        //qcar->drawMarkerCenter();
        //qcar->drawMarkerCorners();
        
        ofSetColor(ofColor::white);
        ofSetLineWidth(1);
        
        ofEnableDepthTest();
        
        qcar->begin();
        ofNoFill();
        ofSetColor(255, 0, 0, 200);
        ofSetLineWidth(6);
        ofPushMatrix();
        ofTranslate(markerPoint.x, markerPoint.y);
        ofSetColor(255, 255, 255, 240);
        
        //select image according to marker recognized:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        if(qcar->getMarkerName() == "Andrea_Stalder") thesis[0].draw(20,60);
        else if(qcar->getMarkerName() == "Dario_Lanfranconi") thesis[1].draw(20,60);
        else if(qcar->getMarkerName() == "Flurina_Stuppan") thesis[2].draw(20,60);
        else if(qcar->getMarkerName() == "Kilian_Bannwart") thesis[3].draw(20,60);
        else if(qcar->getMarkerName() == "Meret_Buser") thesis[4].draw(20,60);
        else if(qcar->getMarkerName() == "Sigrist_Monika") thesis[5].draw(20,60);
        else if(qcar->getMarkerName() == "Raisa_Durandi") thesis[6].draw(20,60);
        else if(qcar->getMarkerName() == "Severin_BIgler") thesis[7].draw(20,60);
        else if(qcar->getMarkerName() == "Thomas_Egli") thesis[8].draw(20,60);
        else if(qcar->getMarkerName() == "Simon_Zangger") thesis[9].draw(20,60);
        //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
        ofSetColor(200, 30, 130);
        
        ofPopMatrix();
        ofFill();
        ofSetColor(255);
        ofSetLineWidth(1);
        qcar->end();
    }
    
    ofDisableDepthTest();
    
    /**
     *  access to camera pixels.
     */
    int cameraW = qcar->getCameraWidth();
    int cameraH = qcar->getCameraHeight();
    unsigned char * cameraPixels = qcar->getCameraPixels();
    if(cameraW > 0 && cameraH > 0 && cameraPixels != NULL) {
        if(cameraImage.isAllocated() == false ) {
            cameraImage.allocate(cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        }
        cameraImage.setFromPixels(cameraPixels, cameraW, cameraH, OF_IMAGE_GRAYSCALE);
        if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_PORTRAIT) {
            cameraImage.rotate90(1);
        } else if(qcar->getOrientation() == OFX_QCAR_ORIENTATION_LANDSCAPE) {
            cameraImage.mirror(true, true);
        }
        ofPopStyle();
    }
    
    if(bPressed) {
        ofSetColor(ofColor::red);
        ofDrawBitmapString("touch x = " + ofToString((int)touchPoint.x), ofGetWidth() - 140, ofGetHeight() - 40);
        ofDrawBitmapString("touch y = " + ofToString((int)touchPoint.y), ofGetWidth() - 140, ofGetHeight() - 20);
        ofSetColor(ofColor::white);
    }
}

//--------------------------------------------------------------
void ofApp::exit(){
    ofxQCAR::getInstance()->exit();
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchPoint.set(touch.x, touch.y);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    touchPoint.set(-1, -1);
    markerPoint = ofxQCAR::getInstance()->screenPointToMarkerPoint(ofVec2f(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}

