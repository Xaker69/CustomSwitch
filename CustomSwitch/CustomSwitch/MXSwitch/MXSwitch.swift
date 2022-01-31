import UIKit

@IBDesignable
class MXSwitch: UIControl {
    
    @IBInspectable
    var isOn: Bool = true
    
    var animationDuration: Double = 0.3
    
    @IBInspectable
    var padding: CGFloat = 1 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var onTintColor: UIColor = .systemGreen {
        didSet {
            setupUI()
        }
    }
    
    @IBInspectable
    var offTintColor: UIColor = .white {
        didSet {
            setupUI()
        }
    }
    
    var cornerRadius: CGFloat? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var thumbImageInsets: UIEdgeInsets = .zero {
        didSet {
            thumbView.imageInsets = thumbImageInsets
            thumbView.layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var thumbTintColor: UIColor = .white {
        didSet {
            thumbView.backgroundColor = thumbTintColor
        }
    }
    
    var thumbCornerRadius: CGFloat? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var thumbSize: CGSize = CGSize.zero {
        didSet {
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var thumbImage: UIImage? = nil {
        didSet {
            guard let image = thumbImage else { return }
            thumbView.thumbImageView.image = image
        }
    }
    
    var onImage: UIImage? {
        didSet {
            onImageView.image = onImage
            layoutIfNeeded()
        }
    }
    
    var offImage: UIImage? {
        didSet {
            offImageView.image = offImage
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var thumbShadowColor: UIColor = UIColor.black {
        didSet {
            thumbView.layer.shadowColor = thumbShadowColor.cgColor
        }
    }
    
    @IBInspectable
    var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
        didSet {
            thumbView.layer.shadowOffset = thumbShadowOffset
        }
    }
    
    @IBInspectable
    var thumbShadowRadius: CGFloat = 1.5 {
        didSet {
            thumbView.layer.shadowRadius = thumbShadowRadius
        }
    }
    
    @IBInspectable
    var thumbShadowOppacity: Float = 0.4 {
        didSet {
            thumbView.layer.shadowOpacity = thumbShadowOppacity
        }
    }
    
    @IBInspectable
    var thumbBorderColor: UIColor = .white {
        didSet {
            thumbView.layer.borderColor = thumbBorderColor.cgColor
        }
    }
    
    @IBInspectable
    var thumbBorderWidth: CGFloat = 0.0 {
        didSet {
            thumbView.layer.borderWidth = thumbBorderWidth
        }
    }
    
    var labelOff = UILabel()
    var labelOn = UILabel()
    
    var areLabelsShown: Bool = false {
        didSet {
            setupUI()
        }
    }

    private var thumbView = MXThumbView()
    private var onImageView = UIImageView()
    private var offImageView = UIImageView()
    
    private var onPoint = CGPoint.zero
    private var offPoint = CGPoint.zero
    private var isAnimating = false
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    func setOnWithoutAction(_ isOn: Bool) {
        self.isOn = isOn
        setupViewsOnAction()
    }
    
    private func setupUI() {
        clear()
        
        clipsToBounds = false
        
        thumbView.backgroundColor = thumbTintColor
        thumbView.isUserInteractionEnabled = false
        
        thumbView.layer.shadowColor = thumbShadowColor.cgColor
        thumbView.layer.shadowRadius = thumbShadowRadius
        thumbView.layer.shadowOpacity = thumbShadowOppacity
        thumbView.layer.shadowOffset = thumbShadowOffset
        
        thumbView.layer.borderWidth = thumbBorderWidth
        thumbView.layer.borderColor = thumbBorderColor.cgColor
        
        backgroundColor = isOn ? onTintColor : offTintColor
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
            thumbView.layer.cornerCurve = .continuous
        }
        
        addSubview(thumbView)
        addSubview(onImageView)
        addSubview(offImageView)
        
        setupLabels()
    }
    
    private func clear() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        animate()
        return true
    }
    
    func setOn(on: Bool, animated: Bool) {
        
        switch animated {
        case true:
            animate(on: on)
        case false:
            isOn = on
            setupViewsOnAction()
            completeAction()
        }
    }
    
    private func animate(on: Bool? = nil) {
        isOn = on ?? !isOn
        isAnimating = true
        completeAction()
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.setupViewsOnAction()
            
        }, completion: { _ in
            self.isAnimating = false
        })
    }
    
    private func setupViewsOnAction() {
        thumbView.frame.origin.x = isOn ? onPoint.x : offPoint.x
        backgroundColor = isOn ? onTintColor : offTintColor
        setOnOffImageFrame()
    }
    
    private func completeAction() {
        sendActions(for: .valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAnimating {
            layer.cornerRadius = cornerRadius != nil ? cornerRadius! : bounds.height/2
            backgroundColor = isOn ? onTintColor : offTintColor
            
            let thumbSize = thumbSize != CGSize.zero ? thumbSize : CGSize(width: bounds.size.height - (padding * 2), height: bounds.height - (padding * 2))
            let yPostition = (bounds.size.height - thumbSize.height) / 2
            
            onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPostition)
            offPoint = CGPoint(x: padding, y: yPostition)
            
            let radius = thumbSize.width > thumbSize.height ? thumbSize.height/2 : thumbSize.width/2
            thumbView.frame = CGRect(origin: isOn ? onPoint : offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbCornerRadius != nil ? thumbCornerRadius! : radius
            
            
            if areLabelsShown {
                let labelWidth = bounds.width / 2 - padding * 2
                labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: frame.height)
                labelOff.frame = CGRect(x: frame.width - labelWidth, y: 0, width: labelWidth, height: frame.height)
            }
            
            // on/off images
            //set to preserve aspect ratio of image in thumbView
            
            guard onImage != nil && offImage != nil else { return }
            
            let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
            let onOffImageSize = CGSize(width: frameSize, height: frameSize)
            
            
            onImageView.frame.size = onOffImageSize
            offImageView.frame.size = onOffImageSize
            
            onImageView.center = CGPoint(x: onPoint.x + thumbView.frame.size.width / 2, y: thumbView.center.y)
            offImageView.center = CGPoint(x: offPoint.x + thumbView.frame.size.width / 2, y: thumbView.center.y)
            
            
            onImageView.alpha = isOn ? 1.0 : 0.0
            offImageView.alpha = isOn ? 0.0 : 1.0
        }
    }
    
    
    private func setupLabels() {
        guard areLabelsShown else {
            labelOff.alpha = 0
            labelOn.alpha = 0
            return
        }
        
        labelOff.alpha = 1
        labelOn.alpha = 1
        
        let labelWidth = bounds.width / 2 - padding * 2
        labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: frame.height)
        labelOff.frame = CGRect(x: frame.width - labelWidth, y: 0, width: labelWidth, height: frame.height)
        labelOn.font = UIFont.boldSystemFont(ofSize: 12)
        labelOff.font = UIFont.boldSystemFont(ofSize: 12)
        labelOn.textColor = UIColor.white
        labelOff.textColor = UIColor.white
        
        labelOff.sizeToFit()
        labelOff.text = "Off"
        labelOn.text = "On"
        labelOff.textAlignment = .center
        labelOn.textAlignment = .center
        
        insertSubview(labelOff, belowSubview: thumbView)
        insertSubview(labelOn, belowSubview: thumbView)
        
    }
    
    
    
    private func setOnOffImageFrame() {
        guard onImage != nil && offImage != nil else { return }
        
        onImageView.center.x = isOn ? onPoint.x + thumbView.frame.size.width / 2 : frame.width
        offImageView.center.x = !isOn ? offPoint.x + thumbView.frame.size.width / 2 : 0
        onImageView.alpha = isOn ? 1.0 : 0.0
        offImageView.alpha = isOn ? 0.0 : 1.0
    }
}
