# Moots
everything is the best arrangement

## 1、常用代码

#### 导航栏标题设置
```swift
// 需要tabBarItem的title与导航栏title不一致,如下设置navigationbar的titile
navigationItem.title = "示例"
注意: 直接 title = "示例" 在tabbar切换时tabBarItem的title会变成设置
```

#### tableView分割线左边到头
```swift
//写在viewDidLoad
if tableView.respondsToSelector(Selector("setSeparatorInset:")) {
    tableView.separatorInset = UIEdgeInsetsZero
}
if tableView.respondsToSelector(Selector("setLayoutMargins:")) {
    tableView.layoutMargins = UIEdgeInsetsZero
}

//写在 willDisplayCell
if cell.respondsToSelector(Selector("setSeparatorInset:")) {
    cell.separatorInset = UIEdgeInsetsZero
}
if cell.respondsToSelector(Selector("setLayoutMargins:")) {
    cell.layoutMargins = UIEdgeInsetsZero
}
```

#### 虚线
```swift
func drawDottedLine(lineView: UIView, offset: CGPoint) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.bounds = lineView.bounds
    shapeLayer.position = lineView.layer.position
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = MOOTS_LINE_GRAY.CGColor
    shapeLayer.lineWidth = 0.5
    shapeLayer.lineJoin = kCALineJoinRound
    // 4=线的宽度 1=每条线的间距
    shapeLayer.lineDashPattern = [NSNumber(int: 4), NSNumber(int: 1)]
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, offset.x, offset.y)
    CGPathAddLineToPoint(path, nil, CGRectGetWidth(lineView.frame) - offset.x, offset.y)
    shapeLayer.path = path
    lineView.layer.addSublayer(shapeLayer)
}
```

#### 部分圆角图片
```swift
func cornerImage(frame: CGRect, image: UIImage, Radii: CGSize) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.frame = frame
    let bezierPath = UIBezierPath(roundedRect: imageView.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: Radii)
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = bezierPath.CGPath
    imageView.layer.mask = shapeLayer
    return imageView
}
```

#### 通过字符串构建类
```swift
extension String {
    func fromClassName() -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + self
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}

extension NSObject {
    class func fromClassName(className: String) -> NSObject {
        let className = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
}
```

#### 修改状态栏背景颜色
```swift
func setStatusBarBackgroundColor(color: UIColor) {
    guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
        return
    }
    statusBar.backgroundColor = color
}
```

#### 裁剪图片
```swift
extension UIImage {
    func cutOutImageWithRect(rect: CGRect) -> UIImage {

        guard let subImageRef = CGImageCreateWithImageInRect(CGImage, rect) else {
            return self
        }
        let smallBounds = CGRect(x: 0, y: 0, width: CGImageGetWidth(subImageRef), height: CGImageGetHeight(subImageRef))
        UIGraphicsBeginImageContext(smallBounds.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, smallBounds, subImageRef)
        let smallImage = UIImage(CGImage: subImageRef)
        UIGraphicsEndImageContext()
        return smallImage
    }
}
```

#### 响应区域太小
```swift
extension UIButton {
    //处理button太小
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.hidden || !self.userInteractionEnabled || self.alpha < 0.01 { return nil }

        // increase the hit frame to be at least as big as `minimumHitArea`
        let buttonSize = bounds.size
        let widthToAdd = max(44 - buttonSize.width, 0)
        let heightToAdd = max(44 - buttonSize.height, 0)
        let method = CGRect.insetBy(bounds)
        let largerFrame = method(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        // perform hit test on larger frame
        return largerFrame.contains(point) ? self : nil
    }
}
```

## 2、笔记
##### Class

##### Protocol
>delegate一般得用weak标识符，这样当delegate指向的controller被销毁时，delegate会跟着被置为nil，可以有效防止这种问题。
若是使用assign标识的delegate，则注意在delegate指向的对象被销毁时，将delegate 置为nil。
也有不将delegate置为nil，没有问题的情况。如常见的tableView，其delegate和datasource，一般不会在其他controller中使用该tableView，所以不会有这种问题。


##### Struct
>实例方法中修改值类型
结构体和枚举是值类型。默认情况下，值类型的属性不可以在他的实例方法中修改
可以用mutating（变异行为）
注意：不能在结构体类型常量上调用变异方法，因为常量的属性不能被改变，即使想改变的是常量的变量属性也不行

##### UITableView
>在UITableViewCell实例上添加子视图，有两种方式：[cell  addSubview:view]或[cell.contentView addSubview:view],一般情况下，两种方式没有区别。但是在多选编辑状态，直接添加到cell上的子视图将不会移动，而添加在contentView上的子视图会随着整体右移。所以，推荐使用[cell.contentView addSubview:view]方式添加子视图。

>cell.backgroundColor = [UIColor grayColor];或cell.contentView.backgroudColor = [UIColor grayColor];一般情况下，两种方式效果一样。但是在多选编辑状态，直接设置cell的背景色可以保证左侧多选框部分的背景色与cell背景色一致，而设置contentView背景色，左侧多选框的背景色会是UITableView的背景色或UITableView父视图背景色，如果需要保证颜色一致，必须设置cell的背景色而不是cell.contentView的。

##### 杂
> Self 表示引用当前实例的类型

>AnyObject可以代表任何class类型的实例

>Any可以表示任何类型。除了方法类型（function types）

>对于生命周期中会变为nil的实例使用弱引用。相反地，对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用。

## 3、常用配置

#### cocoapods
```ruby
卸载当前版本
sudo gem uninstall cocoapods

下载旧版本
sudo gem install cocoapods -v 0.25.0
```

#### 修改Xcode自动生成的文件注释来导出API文档
```
http://www.jianshu.com/p/d0c7d9040c93
open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Templates/File\ Templates/Source
```

#### 删除多余模拟器
```
open /Library/Developer/CoreSimulator/Profiles/Runtimes
```

#### 修改swift文件
```
open /Applications/Xcode.app/Contents/Developer/Library/Xcode/Templates/File\ Templates/Source/Swift\ File.xctemplate
```

## 4、错误处理
> The certificate used to sign "XXX" has either expired or has been revoked
>[解决方法](http://www.cnblogs.com/zzugyl/p/5555695.html)
> [然后](http://stackoverflow.com/questions/32730312/reason-no-suitable-image-found/32730393#32730393)

## 5、其他
#### [markdown语法](http://www.jianshu.com/p/f3fd881548ad)
#### [public podspec](http://www.jianshu.com/p/98407f0c175b)
#### [private podspec](http://www.cocoachina.com/ios/20150228/11206.html)
