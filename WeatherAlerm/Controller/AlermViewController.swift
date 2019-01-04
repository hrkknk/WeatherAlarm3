//
//  ViewController.swift
//  WeatherAlerm
//
//  Created by 金子宏樹 on 2018/08/12.
//  Copyright © 2018年 金子宏樹. All rights reserved.
//

import UIKit
import os.log

class AlermViewController: UIViewController {

    // MARK: - Properties
    var alerm: Alerm?

    //MARK: - Outlets
    @IBOutlet weak var sunnyAlermDatePicker: UIDatePicker!
    @IBOutlet weak var rainyAlermDatePicker: UIDatePicker!
    @IBAction func alermSetButton(_ sender: UIButton) {
        saveAlerm()
    }
    
    //MARK: - Actions
//    @IBAction func cancel(_ sender: UIBarButtonItem) {
//        //AddAlermで遷移したかEditAlermで遷移したかによってcancelの方法を変える
//        if presentingViewController is UINavigationController {
//            dismiss(animated: true, completion: nil)
//        }
//        else if let owningNavigationController = navigationController {
//            owningNavigationController.popViewController(animated: true)
//        }
//        else {
//            fatalError("The MealViewController is not inside a navigation controller.")
//        }
//    }
    
    @IBAction func setSunnyAlerm(_ sender: UIDatePicker) {
        alerm!.sunnyAlermTime = sender.date
    }
    @IBAction func setRainyAlerm(_ sender: UIDatePicker) {
        alerm!.rainyAlermTime = sender.date
    }
    //MARK: - Methods
    override func viewDidLoad() {

        super.viewDidLoad()
        
        //TODO: データロード
        //保存データがある場合、それを読み込む
        if let savedAlerm = loadAlerm() {
            alerm = savedAlerm
        } else {
            // Load the sample data.
//            alerm += loadSampleAlerm()
        }
        //編集モードの場合、各UIの値を前画面から渡されたアラームの内容に更新
        if let alerm = alerm {
            //時刻引き継ぎ
            self.sunnyAlermDatePicker.date = alerm.sunnyAlermTime
            self.rainyAlermDatePicker.date = alerm.rainyAlermTime
            //TODO: 他のUIも初期化
        } else { //編集モードでない場合、新規アラーム追加用にalermを初期化
            alerm = Alerm(sunnyAlermTime: sunnyAlermDatePicker.date, rainyAlermTime: rainyAlermDatePicker.date)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
//        //セグエによる画面遷移ではない場合、ボタン押下処理を行う
//        if(segue.identifier == nil) {
//            guard let button = sender as? UIBarButtonItem, button === saveButton else {
//                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
//                return
//            }
//
//            //AddAlermで遷移してきた場合は新規にアラームを生成
//            //EditAlerm遷移してきた場合はアラームを更新
//            alerm = Alerm(sunnyAlermTime: SunnyAlermDatePicker.date, rainyAlermTime: RainyAlermDatePicker.date)
//            return
//        }
        
        switch(segue.identifier ?? "") {
            //セグエがSelectWeatherだったら画面遷移の準備処理を行う
            case "SelectWeather":
                //UINavigationControllerを取得
                guard let navigationController = segue.destination as? UINavigationController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
//                //UINavigationControllerの次の画面(WeatherViewController)を取得
//                guard let weatherViewController = navigationController.topViewController as? WeatherViewController else {
//                    fatalError("Unexpected topViewController: \(String(describing: navigationController.topViewController))")
//                }
            
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    private func saveAlerm() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(alerm, toFile: Alerm.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Alerm successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save alerm...", log: OSLog.default, type: .error)
        }
    }

    private func loadAlerm() -> Alerm?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alerm.ArchiveURL.path) as? Alerm
    }
}

