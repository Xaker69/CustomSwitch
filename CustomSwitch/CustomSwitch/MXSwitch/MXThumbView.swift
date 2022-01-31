import UIKit

final class MXThumbView: UIView {
    
    var imageInsets: UIEdgeInsets = .zero
    
    let thumbImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(thumbImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        let width = bounds.width - imageInsets.left - imageInsets.right
        let height = bounds.height - imageInsets.top - imageInsets.bottom
        thumbImageView.frame = CGRect(x: imageInsets.left, y: imageInsets.top, width: width, height: height)
        
        thumbImageView.layer.cornerRadius = layer.cornerRadius
        thumbImageView.clipsToBounds = clipsToBounds
    }
    
}
