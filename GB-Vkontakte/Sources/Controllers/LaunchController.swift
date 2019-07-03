//
//  LaunchController.swift
//  GB-Vkontakte
//
//  Created by Vitalik on 17.05.2019.
//  Copyright © 2019 Vit. All rights reserved.
//

import UIKit

class LaunchController: UIViewController {
    
    //MARK: - Outlets
  
    @IBOutlet weak var labelVK: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    
    // кнопка входа
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
    // время для таймера
    var timerSeconds = 3
    
    //MARK: - LIfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // жест нажатия для скрытия клавиатуры
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        //добавляем его scrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        // загругление краев кнопки входа
        self.loginButton.layer.cornerRadius = 5
        animateTitleVK()
        animateEnterButton()
        
        // передаем данные в статическое свойство класса
        let session = Session.instance
        session.token = "abc123"
        session.userId = 432290
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // подписываемся на уведомление при появление клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // уведомление при пропадании клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // показываем индикатор загрузки ThreePointsIndicator
        let progressStatusIndicator = ThreePointsIndicator(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height))
        progressStatusIndicator.tag = 100
        view.addSubview(progressStatusIndicator)
        
        // таймер для удаления индикатора
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerSeconds -= 1
            if self.timerSeconds == 0 {
                timer.invalidate()
                progressStatusIndicator.removeFromSuperview()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Mark: - Segue
    
    // переопределяем метод проверки логина и пароля
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        let checkUserName = checkUserData()
        if !checkUserName {
            showIdentError()
        }
        return checkUserName
    }
    
    // Mark: - Functions
    
    // функция проверки введеныых данных
    func checkUserData() -> Bool {
        // проверка наличия логина и пароля
        guard let login = userNameTextField.text,
            let password = passwordTextField.text else {return false}
        // проверка правильности логина и пароля
        if login == "" && password == "" {
            return true
        } else {
            // если ввод неверный, поле пароля очищается
            passwordTextField.text = ""
            return false
        }
    }
    
    // функция показа сообщения об ошибке
    func showIdentError() {
        // создаем алерт для предупреждения о неверном вводе
        let alertWIndow = UIAlertController(title: "Warning!", message: "Invalid username or passsword", preferredStyle: .alert)
        // кнопка для UIAlertController
        let actionButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        // добавляем кнопку на UIAlertController
        alertWIndow.addAction(actionButton)
        // показываем UIAlertController
        present(alertWIndow, animated: true, completion: nil)
    }
    
    //MARK: - Keyboard
    
    // после появления клавиатуры
    @objc func keyboardWasShown(notification: Notification) {
        
        // получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey:
            UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // добавляем отступ внизу UIScrollView,  равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    // после исчезновения клавиатуры
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        // устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // исчезновение клавиатуры при клике по месту на экране
    @objc func hideKeyBoard() {
        self.scrollView?.endEditing(true)
    }
    
    //MARK: - Segues
    
    // метод для перехода на стартовый экран с очисткой полей логина и пароля
    @IBAction func myUNwindAction(unwindSegue: UIStoryboardSegue){
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    //MARK: - Animations
    
    // анимация надписи ВК, вылетает сверху с пружинистостью
    func animateTitleVK () {
        self.labelVK.transform = CGAffineTransform(translationX: 0,
                                                   y: -self.view.bounds.height / 2)
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut,
                       animations: {
                        self.labelVK.transform = .identity
                        },
                       completion: nil)
    }
    
    // анимация кнопки Войти, появляется с увеличением
    func animateEnterButton () {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 100
        animation.mass = 1
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginButton.layer.add(animation, forKey: nil)
    }
}
