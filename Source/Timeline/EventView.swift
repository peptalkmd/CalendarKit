import UIKit
import DateToolsSwift
import Neon

public protocol EventViewDelegate: AnyObject {
    func eventViewDidTap(_ eventView: EventView)
    func eventViewDidLongPress(_ eventview: EventView)
}

public class EventView: UIView {
    
    weak var delegate: EventViewDelegate?
    public var descriptor: EventDescriptor?
    
    public var color = UIColor.lightGray
    
    var contentHeight: CGFloat {
        return textView.height
    }
    
    lazy var textView: UILabel = {
        let view = UILabel()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.numberOfLines = 1
        view.minimumScaleFactor = 0.75
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
    lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        clipsToBounds = true
        [tapGestureRecognizer, longPressGestureRecognizer].forEach {addGestureRecognizer($0)}
        
        color = self.tintColor
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor,constant : 1).isActive = true
        textView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor,constant: 1).isActive = true
    }
    
    func updateWithDescriptor(event: EventDescriptor) {
        if let attributedText = event.attributedText {
            textView.attributedText = attributedText
        } else {
            textView.text = event.text
            textView.textColor = event.textColor
            textView.font = event.font
        }
        descriptor = event
        backgroundColor = event.backgroundColor
        color = event.color
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    @objc func tap() {
        delegate?.eventViewDidTap(self)
    }
    
    @objc func longPress() {
        delegate?.eventViewDidLongPress(self)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        context?.saveGState()
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(5)
        context?.translateBy(x: 0, y: 0.5)
        let x: CGFloat = 0
        let y: CGFloat = 0
        context?.beginPath()
        context?.move(to: CGPoint(x: x, y: y))
        context?.addLine(to: CGPoint(x: x, y: (bounds).height))
        context?.strokePath()
        context?.restoreGState()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        textView.sizeToFit()
    }
}
