//
//  IVViewController.swift
//  Go Pokedex
//
//  Created by antoine beneteau on 28/08/2016.
//  Copyright © 2016 TastyApp. All rights reserved.
//

import UIKit
import QuartzCore


class IVViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, hpModalViewProtocol, cpModalViewProtocol {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var pokemonImage: UIButton!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var stardustLabel: UILabel!
    @IBOutlet weak var cpLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var resultsMainView: UIView!
    @IBOutlet weak var noCombinaisonLabel2: UILabel!
    @IBOutlet weak var noCombinaisonLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var poweredLabel: UILabel!
    
    @IBOutlet weak var poweredSwitchView: UIView!
    @IBOutlet weak var attackDefenseIv: UILabel!
    @IBOutlet weak var staminaIv: UILabel!
    @IBOutlet weak var battleRatingPerCent: UILabel!
    @IBOutlet weak var cpRatingPerCent: UILabel!
    @IBOutlet weak var hpPerCent: UILabel!
    
    let mySwitch = SevenSwitch()
    var powered: Bool = false
    var selectedPokemon: Pokemon!
    
    var pickerViewStardust = UIPickerView()
    var pickerViewLevel = UIPickerView()
    
    var levels = [String]()
    var IV = [IVstruct]()
    var hp = 53
    var cp = 504
    var stardust = 3000
    var level = "21.0"
    
    var hpOK: Bool! = false
    var cpOK: Bool! = false
    var stardustOK: Bool! = false
    var levelOK: Bool! = false
    var levelCanBePressed = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSwitch()
        self.tableView.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        selectedPokemon = pokemonList[3]
        self.pokemonImage.hidden = true
        initStats()
        hideAllStats(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initStats() {
        self.hpLabel.text = "\(self.hp)"
        self.cpLabel.text = "\(self.cp)"
        self.stardustLabel.text = "\(self.stardust)"
        self.levelLabel.text = level
    }
    
    func reloadDatas() {
        
    }
    
    @IBAction func addButtonPressed(sender: AnyObject) {
        self.tableView.hidden = false
        self.navigationItem.title = "Choose your pokemon"
        self.tableView.reloadData()
    }
    @IBAction func pokemonPressed(sender: AnyObject) {
        self.tableView.hidden = false
        self.tableView.reloadData()
        self.navigationItem.title = "Choose your pokemon"
    }
    
    func hideAllStats(hide: Bool) {
        self.attackDefenseIv.hidden = hide
        self.staminaIv.hidden = hide
        self.battleRatingPerCent.hidden = hide
        self.cpRatingPerCent.hidden = hide
        self.hpPerCent.hidden = hide
    }
    
    func initSwitch() {
        mySwitch.addTarget(self, action: #selector(IVViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        mySwitch.offImage = UIImage(named: "cross.png")
        mySwitch.onImage = UIImage(named: "check.png")
        mySwitch.thumbImage = UIImage(named: "thumb.png")
        mySwitch.offLabel.text = ""
        mySwitch.onLabel.text = ""
        mySwitch.thumbTintColor = UIColor(red: 0.19, green: 0.23, blue: 0.33, alpha: 1)
        mySwitch.activeColor =  UIColor(red: 0.07, green: 0.09, blue: 0.11, alpha: 1)
        mySwitch.inactiveColor =  UIColor(red: 0.07, green: 0.09, blue: 0.11, alpha: 1)
        mySwitch.onTintColor =  UIColor(red: 0.45, green: 0.58, blue: 0.67, alpha: 1)
        mySwitch.borderColor = UIColor.clearColor()
        mySwitch.shadowColor = UIColor.blackColor()
        
        mySwitch.frame = poweredSwitchView.bounds
        mySwitch.isRounded = false
        poweredSwitchView.addSubview(mySwitch)
    }
    
    
    func switchChanged(sender: SevenSwitch) {
        if powered {
            powered = false
            poweredLabel.layer.shadowColor = UIColor(red:0.60, green:0.58, blue:0.58, alpha:1.0).CGColor
            poweredLabel.layer.shadowRadius = 0
            poweredLabel.layer.shadowOpacity = 0
            poweredLabel.layer.masksToBounds = false
            poweredLabel.textColor = UIColor(red:0.60, green:0.58, blue:0.58, alpha:1.0)
            self.levelLabel.text = findLevels(self.stardust, powered: powered)[0]
        } else {
            powered = true
            poweredLabel.layer.shadowColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0).CGColor
            poweredLabel.layer.shadowRadius = 4.0
            poweredLabel.layer.shadowOpacity = 0.9
            poweredLabel.layer.shadowOffset = CGSizeZero
            poweredLabel.layer.masksToBounds = false
            poweredLabel.textColor = UIColor(red:0.18, green:0.80, blue:0.44, alpha:1.0)
            self.levelLabel.text = findLevels(self.stardust, powered: powered)[0]
        }
    }
    
    @IBAction func hpPressed(sender: AnyObject) {
        let view = HpModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        view.vc = self
        view.hpTextField.text = "\(self.hp)"
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
                view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!)
    }
    @IBAction func cpPressed(sender: AnyObject) {
        let view = CpModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        view.vc = self
        view.cpTextField.text = "\(self.cp)"
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!)
    }
    @IBAction func stardustPressed(sender: AnyObject) {
        let view = StardustModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal()
        view.vc = self
        view.pickerView.selectRow(self.stardust, inComponent: 0, animated: true)
        view.stardustTextField.text = "\(self.stardust)"
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
            view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!)
    }
    @IBAction func levelPressed(sender: AnyObject) {
        if  levelCanBePressed {
            let view = LevelModalView.instantiateFromNib()
            let window = UIApplication.sharedApplication().delegate?.window!
            let modal = PathDynamicModal()
            view.vc = self
            view.levelsToPick = findLevels(self.stardust, powered: powered)
            view.levelTextField.text = (findLevels(self.stardust, powered: powered))[0]
            view.pickerView.selectRow(0, inComponent: 0, animated: true)
            modal.showMagnitude = 200.0
            modal.closeMagnitude = 130.0
            view.bottomButtonHandler = {[weak modal] in
                modal?.closeWithLeansRandom()
                return
            }
            modal.show(modalView: view, inView: window!)
        } else {
            print("Can't choose level now")
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        (cell.viewWithTag(100) as! UIImageView).image = pokemonList[indexPath.row].img
        (cell.viewWithTag(101) as! UILabel).text = pokemonList[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.selectedPokemon = pokemonList[indexPath.row]
            self.pokemonImage.hidden = false
            self.addButton.hidden = true
            self.pokemonImage.setImage(pokemonList[indexPath.row].img, forState: .Normal)
            self.tableView.hidden = true
            self.navigationItem.title = selectedPokemon.name
    }
    
    
    func passHp(hp: Int) {
        self.hp = hp
        self.hpLabel.text = "\(self.hp)"
        print(self.hp)
        print("hp sent")
        self.hpOK = true
    }
    
    func passCp(cp: Int) {
        self.cp = cp
        self.cpLabel.text = "\(self.cp)"
        print(self.cp)
        print("cp sent")
        self.cpOK = true
    }
    
    func passStardust(stardust: Int) {
        self.stardust = stardust
        self.stardustLabel.text = "\(self.stardust)"
        print(self.stardust)
        print("stardust sent")
        self.stardustOK = true
        self.levelCanBePressed = true
        self.levelLabel.text = findLevels(self.stardust, powered: powered)[0]
    }
    
    func passLevel(level: String) {
        self.level = level
        self.levelLabel.text = "\(self.level)"
        print(self.level)
        print("level sent")
        self.levelOK = true
    }
    
    
    
    
}
