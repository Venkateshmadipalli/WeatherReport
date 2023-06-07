//
//  ViewController.swift
//  WetherConditionApp
//
//  
//


//
import UIKit
class ViewController: UIViewController,WetherApi {

    let cardView = UIView()
    let Lable = UILabel()
    let cityNameTF = UITextField()
    let mainPickerView = UIPickerView()
    var MainTableView = UITableView()
    let key = "522db6a157a748e2996212343221502"
    var statesList = ["Andhra Pradesh", "chennai", "Kerala","Goa", "Mumbai"]
    let APIHit = WetherAPIHit()
    var responceData = [String:Any]()
    let rotate = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        createMainView()
        addTableView()
        MainTableView.register(
            WetherTableViewCell.self,
            forCellReuseIdentifier: WetherTableViewCell.identifier)
        cityNameTF.text = statesList[0]


        mainPickerView.dataSource = self
        mainPickerView.delegate = self
        cityNameTF.delegate = self
        cityNameTF.inputView = mainPickerView
        APIHit.wetherApi(key: key, state: cityNameTF.text!)
        APIHit.delegate = self
        // Do any additional setup after loading the view.
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")

    }


//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return [.portrait, .landscapeLeft, .landscapeRight]
//
//    }
//
//
//    override var shouldAutorotate: Bool {
//        return true
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        self.MainTableView.reloadData()
        self.MainTableView.setNeedsLayout()
        self.MainTableView.layoutIfNeeded()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.MainTableView.setNeedsLayout()
        self.MainTableView.layoutIfNeeded()
        self.MainTableView.reloadData()

        MainTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    fileprivate func addTableView() {
        let detailCardHeight = self.view.frame.height / 6 + 30
        MainTableView.topAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: detailCardHeight + 30
        ).isActive = true
        MainTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
            .isActive =
        true
        MainTableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor)
            .isActive =
        true
        MainTableView.heightAnchor.constraint(
            equalTo: self.view.safeAreaLayoutGuide.heightAnchor, constant: -detailCardHeight - 30
        ).isActive = true

        MainTableView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        MainTableView.delegate = self
        MainTableView.dataSource = self
        
        
        

        //        tableView.heightAnchor.constraint(equalToConstant: self.view.frame.height).isActive = true
    }



    func createMainView(){
        let detailCardHeight = self.view.frame.height / 6 - 30
        print(detailCardHeight,"detailCardHeight")
        cardView.frame = CGRect(
            x: 10, y: 80, width: self.view.frame.width - 20, height: detailCardHeight + 20)

        Lable.frame = CGRect(
            x: 20, y: Int(20), width: Int(cardView.bounds.width - 20), height: 15)
        cityNameTF.frame = CGRect(
            x: 20, y: Int(60), width: Int(cardView.bounds.width - 40), height: 40)

        cardView.layer.cornerRadius = 10
        cardView.layer.borderColor = UIColor.lightGray.cgColor
        cardView.layer.borderWidth = 0.2
        //cardView.layer.shadowOpacity = 0.4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.masksToBounds = false

        Lable.text = "Please Select State"
        cityNameTF.placeholder = "please select state"
        cityNameTF.borderStyle = .roundedRect
        self.MainTableView = UITableView(frame: self.MainTableView.frame, style: .grouped)
        view.addSubview(cardView)
        view.addSubview(MainTableView)
        cardView.addSubview(Lable)
        cardView.addSubview(cityNameTF)

    }
    func Succes(data: [String : Any]) {

        if data.count > 0 && data != nil{

           responceData = data
            print("responceData",responceData)
            DispatchQueue.main.async {
                self.MainTableView.reloadData()
                LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
            }

        }



    }

    func Fail() {
        LoadingUtils.shared.hideActivityIndicator(uiView: self.view)
        print("fail")
    }



}

extension ViewController:UITextFieldDelegate{

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        mainPickerView.isHidden = false
        return false
    }

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return statesList.count
    }

    func pickerView(_ pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        print(statesList[row])
        return statesList[row]
    }

    func pickerView(_ pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        LoadingUtils.shared.showActivityIndicator(uiView: self.view)
        cityNameTF.text = statesList[row]
        //mainPickerView.isHidden = true;
        APIHit.wetherApi(key: key, state: cityNameTF.text!)
        cityNameTF.resignFirstResponder()
    }

}
extension ViewController : UITableViewDelegate,UITableViewDataSource{


    func numberOfSections(in tableView: UITableView) -> Int {
        if responceData.count > 0 && responceData != nil{
            return 1
        }else{
            return 0
        }

    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if responceData.count > 0 && responceData != nil{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        let lineView = UILabel(frame: CGRect(x: 15, y: 25, width: 2, height: 20))
        lineView.backgroundColor = .red
        let label = UILabel(
            frame: CGRect(x: 23, y: 20, width: self.view.frame.width - 80, height: 30))
        let label2 = UILabel(
                frame: CGRect(x: 23, y: 55, width: self.view.frame.width - 80, height: 30))
            let location = responceData["location"] as! [String:Any]
            label2.text = " \(location["name"] as! String), \(location["country"] as! String), \(location["localtime"] as! String)"
            let data = responceData["forecast"] as! [String:Any]
            let forecastday = data["forecastday"] as! [[String:Any]]
            label.numberOfLines = 0
            label.text = "\(forecastday.count) days Wether conditions List in \(location["name"] as! String)"
            label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textAlignment = .left
        view.addSubview(label)
            view.addSubview(label2)
        view.addSubview(lineView)

            return view
        }else{
            return nil
        }


    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = responceData["forecast"] as! [String:Any]
        let forecastday = data["forecastday"] as! [[String:Any]]
        return forecastday.count
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let wetherCell = WetherTableViewCell()

         let resData = responceData["forecast"] as! [String:Any]
        let forecastday = resData["forecastday"] as! [[String:Any]]
        let date = forecastday[indexPath.row]["date"] as! String
        let day = forecastday[indexPath.row]["day"] as! [String:Any]
        let condtions = day["condition"] as! [String:Any]
        let currentWether = condtions["text"] as! String
        let currentWetherIcon = condtions["icon"] as! String
        let newStr = currentWetherIcon.replacingOccurrences(of: "//", with: "")

        if let urlString = newStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: urlString) {

            //DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        wetherCell.forcastIcon.image = image
                    }
                }else{
                    wetherCell.forcastIcon.image = UIImage(named: "176")
                    print("error")
                }
            //}
        }

        let minTempC = day["mintemp_c"] as! NSNumber
        let maxTempC = day["maxtemp_c"] as! NSNumber
        wetherCell.currentWeather.text = currentWether

        wetherCell.minAndMaxLable.text = "mintemp : \(minTempC) ,maxtemp : \(maxTempC) "
        wetherCell.currentDate.text = "Date : \(date)"

        return wetherCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
