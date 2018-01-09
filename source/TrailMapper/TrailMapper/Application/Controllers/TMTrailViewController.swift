//
//  TMTrailViewController.swift
//  TrailMapper
//
//  Created by Tim Sutton on 2018/01/08.
//  Copyright © 2018 Kartoza Pty Ltd. All rights reserved.
//

import ALCameraViewController
import CoreLocation
import UIKit

class TMTrailViewController: UIViewController, CLLocationManagerDelegate,UITextFieldDelegate {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var trailImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var txtFieldTrailName: UITextField!
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var btnAddNotes: UIButton!
    
    //MARK:- Variables & Constants
    let locationManager = CLLocationManager() // for getting GPS coords
    var currentLocationCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()// for storing last coord
    var trailImageLocalPath = "No Image available"
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // configuration for things relating to location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Add save trail button in navigation bar
        let saveTrailButton = UIBarButtonItem.init(title: "Save", style: .done, target: self, action: #selector(self.btnSaveTrailTapped))
        self.navigationItem.rightBarButtonItem = saveTrailButton

        self.getAllTrails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

    // MARK:- Core Location Methods
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation])
    {
        // I searched long and hard to get the location direct from the image.
        // You can get it from a photo roll image but not one direclty captured
        // by using the camera. See https://stackoverflow.com/a/42888731
        // In particular read all the comments there carefully as there are a
        // lot of red herrings where the question is answered based on useing
        // the photo roll.  Because of all these issues, I opted to get the
        // location direct from the GPS rather than the image
        let location = locations[0]
        self.currentLocationCoordinate = location.coordinate
        print("Coordinates: \(self.currentLocationCoordinate.latitude)")
        locationManager.stopUpdatingLocation()
    }

    // MARK:- Image tap related methods
    @IBAction func getImage(_ sender: Any) {
        print("Get Image Button tapped")
        let cameraViewController = CameraViewController { [weak self] image, asset in
            // Do something with your image here.
            self?.trailImage.image = image
            self?.dismiss(animated: true, completion: nil)
            self?.addImageButton.setTitle("Change image ...", for: UIControlState.normal)
            self?.trailImageLocalPath = TMUtility.sharedInstance.saveImage(imagetoConvert: image!, name: "trail_2.png")
        }
        
        present(cameraViewController, animated: true, completion: nil)

    }

    // Save btn event
    @objc func btnSaveTrailTapped() {
        // Code to save all trail info into Local database
        if self.validateTrailInputs() {

            //Create trail model from inputs
            let newTrailModel = TMTrail.init(object: [])

            newTrailModel.name = self.txtFieldTrailName.text
            newTrailModel.notes = "notes txt"
            newTrailModel.image = self.trailImageLocalPath
            newTrailModel.id = 2

            TMDataWrapperManager.sharedInstance.saveTrailToLocalDatabase(trailModel:newTrailModel )
        }
    }


     // MARK: - Custom Class Functions

    // Validate the input parameters for saving trail
    func validateTrailInputs()-> Bool {
        if (self.txtFieldTrailName.text?.isEmpty)! {
            AlertManager.showCustomInfoAlert(Title: TMConstants.kApplicationName, Message: "Please enter valid trail name", PositiveTitle: TMConstants.kAlertTypeOK)
            return false
        }

        return true
    }

    // To get all the trails which is available in local storage
    func getAllTrails() {
        let dataManagerWrapper = TMDataWrapperManager()

            dataManagerWrapper.SDDataWrapperBlockHandler = { (responseArray : NSMutableArray? , responseDict:NSDictionary? , error:NSError? ) -> Void in
                if (responseArray?.count)! > 0 {
                    print("Trail Array --->", responseArray ?? "")

                }
            }
        dataManagerWrapper.callToGetTrailsFromDB(trailId: "")
    }

    //MARK: - UITextField delgate methods
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
