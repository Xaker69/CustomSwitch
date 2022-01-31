import UIKit

class ViewController: UIViewController {

    let switcher = MXSwitch(frame: CGRect(x: UIScreen.main.bounds.width/2 - 50,
                                          y: UIScreen.main.bounds.height/2 - 25,
                                          width: 100,
                                          height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(switcher)
    }


}

