//
//  MapViewController.swift
//  ContactsList
//
//  Created by Daniel Yamrak on 16.09.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!


    override func viewDidLoad() {
        super.viewDidLoad()


    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var searchBarPressed: UISearchBar!

}
