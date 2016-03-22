import Quick
import Nimble

class WallpaperManagerSpec: QuickSpec {
    override func spec() {
        describe("WallpaperManagerImpl") {
            var manager: WallpaperManagerImpl!
            var wallpaperService = WallpaperServiceMock()
            var downloadService = ImageDownloadServiceMock()
            var timer = TimerMock()
            var defaultsStore = UserDefaultsStoreMock()
            
            beforeEach {
                wallpaperService = WallpaperServiceMock()
                downloadService = ImageDownloadServiceMock()
                timer = TimerMock()
                defaultsStore = UserDefaultsStoreMock()
                manager = WallpaperManagerImpl(wallpaperService: wallpaperService, downloadService: downloadService, timer: timer, userDefaultsManager: defaultsStore)
            }
            
            describe("changeWallpaper") {
                it("downloads an image through download service") {
                    manager.changeWallpaper({_ in})
                    
                    expect(downloadService.imageDownloaded).to(equal(true))
                }
                it("sets an image through wallpaper service") {
                    manager.changeWallpaper({_ in})
                    
                    expect(wallpaperService.imageSet).to(equal(true))
                }
            }
            describe("timeIntervalUpdated") {
                it("restarts the timer for positive interval values") {
                    manager.timeIntervalUpdated(1.0)
                    
                    expect(timer.isRunnung).to(equal(true))
                }
                
                it("stops the timer for non positive interval values") {
                    manager.timeIntervalUpdated(0.0)
                    
                    expect(timer.isRunnung).to(equal(false))
                    
                    manager.timeIntervalUpdated(-1.0)
                    
                    expect(timer.isRunnung).to(equal(false))
                }
            }
        }
    }
}

class WallpaperServiceMock: WallpaperService {
    var imageSet = false
    func setWallpaperImageURL(imageURL: NSURL, completionHandler: Result<Bool, ErrorType> -> Void) {
        defer {
            completionHandler(Result.Success(true))
        }
        imageSet = true
        return
    }
}

class ImageDownloadServiceMock: ImageDownloadService {
    var imageDownloaded = false
    func getImage(completionHandler: Result<NSURL, ImageServiceError> -> Void) {
        defer {
            completionHandler(Result.Success(NSURL()))
        }
        imageDownloaded = true
        return
    }
}

class TimerMock: Timer {
    var isRunnung = false
    func start(lastTriggerDate: NSDate, interval: NSTimeInterval, triggerFunction: Void -> Void) {
        isRunnung = true
    }
    
    func stop() {
        isRunnung = false
    }
}