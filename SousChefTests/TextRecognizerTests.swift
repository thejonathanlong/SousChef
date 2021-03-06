//
//  TextRecognizerTests.swift
//  SousChefTests
//
//  Created by Jonathan Long on 1/21/18.
//  Copyright © 2018 jlo. All rights reserved.
//

import XCTest

class TextRecognizerTests: SousChefTestCase {
	
	func testiPhonePhotoFromCookBookIngredients() {
		let semaphore = DispatchSemaphore(value: 0)
		TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto1")!) { (recognizedText) in
			XCTAssertTrue(recognizedText == "ROAST CHICKPEAS\nCOURGETTE & SWEET POTATO\nSPINACH\n\nLONG—GRAIN RICE -\n\nSOFT BOILED EGG\n\nCARROT PICKLE\n\n")
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	func testiPhonePhotoFromCookBookDirections() {
		let semaphore = DispatchSemaphore(value: 0)
		TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto2")!) { (recognizedText) in
			XCTAssertTrue(recognizedText == "FOR THE CARROT PICKLE Scrub 5009 (18 oz.) small carrots and cut them\ninto random batons. Mix together 1 tsp grated fresh turmeric, 1 tsp\ngrated fresh ginger, 1 crushed garlic clove, 1 tsp chili paste, and \njuice of 1 lime (ﬁrst grate the zest and reserve) with a little olive \nHeat a good glug of olive oil in a pan and add 1 tbsp cumin seeds,\n1 tbsp black mustard seeds, the grated zest of 1 lime (from the one\nused forjuice), and 12 curry leaves. As the aromas are released, after\nabout 30 seconds, add the carrots and spice paste, stirring well,\nMeanwhile, heat 300ml (10 fl oz./11/4 cups) vinegar in a separate pan\nand add 1 heaped tbsp coconut sugar or light muscovado sugar.\nWhen the sugar has dissolved, add the vinegar to the carrots, stir, and\nbring to the boil before reducing to a simmer for 10—15 minutes until\nthe carrots are cooked but still have a bite. Allow to cool then transfer to\nan airtightjar. The pickle will keep for up to 2 weeks in the refrigerator.\nFOR THE SWEET POTATO Preheat the oven to 200°C/400°F/gas mark 6.\nScrub 1 small sweet potato, rub with a little olive oil, and score with a I\nsharp knife a couple of times. Roast on a tray in the oven for 40—50\nminutes until cooked but not too soft. Allow to cool before chopping\ninto bite—sized cubes, or simply cut in half. \'\n\n")
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	func testMacScreenShotFromCookingWebsiteIngredients() {
		let semaphore = DispatchSemaphore(value: 0)
		TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto3")!) { (recognizedText) in
			XCTAssertTrue(recognizedText == "1 1/2 cups (200 g) peeled and diced carrots (2 to 3 medium chopped into 1/2-inch pieces)\n1 teaspoon (5 mL) untoasted sesame or olive oil\n\nPinch fine sea salt\n\n1 small garlic clove\n\n3 packed tablespoons (6 g) chopped fresh dill, or more to taste\n\n1 (14-ounce/398 mL) can chickpeas*\n\n1/4 cup (60 mL)tahini\n\n2 tablespoons (30 mL) fresh lemon juice, or more to taste\n\n4 tablespoons (60 mL) chickpea brine or ﬁltered water, or more if needed**\n1 to 2 teaspoons (5 to 10 mL) untoasted sesame oil or light olive oil, to taste\n3/4 to 1 1/4 teaspoons fine sea salt, to taste\n\n")
			semaphore.signal()
		}
		semaphore.wait()
	}
	
	func testMacScreenShotFromCookingWebsiteDirections() {
		let semaphore = DispatchSemaphore(value: 0)
		TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto4")!) { (recognizedText) in
			XCTAssertTrue(recognizedText == "1. Preheat oven to 400°F (200°C) and line a roasting pan with parchment paper.\n\n2. Spread the diced carrots on the roasting pan. Toss them in the teaspoon of oil and\nsprinkle with a pinch of salt. Roast for 32 to 37 minutes, until carrots are fork-tender and\nblackened on the bottom.\n\n3. About 5 to 10 minutes before your carrots are done roasting, place the garlic and fresh\ndill into a large food processor. Process until minced.\n\n4. Drain the chickpeas over a small bowl, reserving the chickpea brine, if using.\n\n5. Next add the drained chickpeas, tahini, lemon juice, chickpea brine (or filtered water, if\nusing), oil, and salt. Process until smooth, stopping to scrape down the side ofthe\nprocessor as necessary.\n\n6. When the carrots are ready, carefully transport them to the processor using the\nparchment paper as a handle to carry. Process the mixture again until smooth. I like to let\nthe machine run for a couple minutes so it gets as smooth as possible. Taste and adjust\ningredients as desired. Feel free to add more dill, lemon, salt, oil or water depending on\nyour preferences.\n\n7. Serve the hummus with a sprinkle of ground cumin, coriander, and fresh minced dill, plus\na drizzle of sesame or olive oil, if desired. Leftover hummus will keep in an airtight\ncontainer in the fridge for about 5 to 7 days.\n\n")
			semaphore.signal()
		}
		semaphore.wait()
	}
    
    func testCroppedImage() {
        let rect = CGRect(x: 65.0, y: 563.972571942446, width: 830.5, height: 855.642985611511)
        let semaphore = DispatchSemaphore(value: 0)
        let cgImage = UIImage(named:"TestPhoto5")!.cgImage?.cropping(to: rect)
        let testImage = UIImage(cgImage: cgImage!)
        TextRecognizer.shared.recognizeText(in: testImage) { (recognizedText) in
            XCTAssertTrue(recognizedText == "3 pounds boneless chicken (thighs or breasts will work)\n1 medium yellow onion, thinly sliced\n\n2 cloves garlic, minced\n\n1 (13.5»ounce) can full—fat coconut milk\n1/3 cup tomato paste\n\n1/2 cup Thai red curry paste\n\n2 tablespoons ﬁsh sauce\n\n2 tablespoons coconut aminos\n\n2 teaspoons fresh |imejuice\n\n2 teaspoons sea salt\n\n3/4 teaspoon ground ginger\n\n4 cups mixed vegetables (frozen orfresh)\n\n")
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func testManyCroppedImages() {
        let rect = CGRect(x: 65.0, y: 563.972571942446, width: 830.5, height: 855.642985611511)
        let semaphore = DispatchSemaphore(value: 0)
        let cgImage = UIImage(named:"TestPhoto5")!.cgImage?.cropping(to: rect)
        var images = [UIImage]()
        for _ in 0...4 {
            let testImage1 = UIImage(cgImage: cgImage!)
            images.append(testImage1)
        }
        
        images.forEach {
            TextRecognizer.shared.recognizeText(in: $0) { (recognizedText) in
                XCTAssertTrue(recognizedText == "3 pounds boneless chicken (thighs or breasts will work)\n1 medium yellow onion, thinly sliced\n\n2 cloves garlic, minced\n\n1 (13.5»ounce) can full—fat coconut milk\n1/3 cup tomato paste\n\n1/2 cup Thai red curry paste\n\n2 tablespoons ﬁsh sauce\n\n2 tablespoons coconut aminos\n\n2 teaspoons fresh |imejuice\n\n2 teaspoons sea salt\n\n3/4 teaspoon ground ginger\n\n4 cups mixed vegetables (frozen orfresh)\n\n")
                semaphore.signal()
            }
        }
        
        semaphore.wait()
        semaphore.wait()
        semaphore.wait()
        semaphore.wait()
        semaphore.wait()
    }
    
    func testCroppingPhoto6ForIngredients() {
        let rect = CGRect(x: 96.0, y: 752.99999999999989, width: 661, height: 322)
        let semaphore = DispatchSemaphore(value: 0)
        let cgImage = UIImage(named:"TestPhoto6")!.cgImage?.cropping(to: rect)
        let testImage = UIImage(cgImage: cgImage!)
        TextRecognizer.shared.recognizeText(in: testImage) { (recognizedText) in
            XCTAssertTrue(recognizedText == "1 (1470unce/398 mL) can youngJackfruit (1n brine)*\n\n2 medlum (140 g) stalks celery, finely chopped\n\n3 medlum (45 g) green onions, thlnly sliced\n\n1/2 cup (67 g) finely chopped red bell pepper\n\n3 tablespoons (45 mL) storerbought vegan mayo or SrMinute MayoH\n1 small (5 g) clove garllc, mlnced\n\n2 to 3 teaspoons (3 g) minced fresh dill\n\n2 to 3 teaspoons (1 O to 15 mL) fresh lemon Julce, to taste\n1/2 teaspoon smoked papnka\n\n1/4 teaspoon flne sea salt, orto taste\n\nFreshly ground black pepper, to taste\n\n")
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func testCroppingPhoto6ForInstructions() {
        let rect = CGRect(x: 91, y: 747.99999999999989, width: 671, height: 332.00000000000023)
        let semaphore = DispatchSemaphore(value: 0)
        let cgImage = UIImage(named:"TestPhoto6")!.cgImage?.cropping(to: rect)
        let testImage = UIImage(cgImage: cgImage!)
        TextRecognizer.shared.recognizeText(in: testImage) { (recognizedText) in
            XCTAssertTrue(recognizedText == "1 (1470unce/398 mL) can youngJackfruit (1n brine)*\n\n2 medlum (140 g) stalks celery, finely chopped\n\n3 medlum (45 g) green onions, thlnly sliced\n\n1/2 cup (67 g) finely chopped red bell pepper\n\n3 tablespoons (45 mL) storerbought vegan mayo or SrMinute MayoH\n1 small (5 g) clove garllc, mlnced\n\n2 to 3 teaspoons (3 g) minced fresh dill\n\n2 to 3 teaspoons (1 O to 15 mL) fresh lemon Julce, to taste\n1/2 teaspoon smoked papnka\n\n1/4 teaspoon flne sea salt, orto taste\n\nFreshly ground black pepper, to taste\n\n")
            semaphore.signal()
        }
        semaphore.wait()
    }
    
    func testTwoImagesAtOnce() {
        let semaphore = DispatchSemaphore(value: 0)
        TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto1")!) { (recognizedText) in
            XCTAssertTrue(recognizedText == "ROAST CHICKPEAS\nCOURGETTE & SWEET POTATO\nSPINACH\n\nLONG—GRAIN RICE -\n\nSOFT BOILED EGG\n\nCARROT PICKLE\n\n")
            semaphore.signal()
        }
        TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto1")!) { (recognizedText) in
            XCTAssertTrue(recognizedText == "ROAST CHICKPEAS\nCOURGETTE & SWEET POTATO\nSPINACH\n\nLONG—GRAIN RICE -\n\nSOFT BOILED EGG\n\nCARROT PICKLE\n\n")
            semaphore.signal()
        }
        semaphore.wait()
        semaphore.wait()
        
    }
//    func testPerformanceTesseract() {
//        self.measure {
//			let semaphore = DispatchSemaphore(value: 0)
//			TextRecognizer.shared.recognizeText(in: UIImage(named:"TestPhoto4")!) { (recognizedText) in
//				XCTAssertTrue(recognizedText == "1. Preheat oven to 400°F (200°C) and line a roasting pan with parchment paper.\n\n2. Spread the diced carrots on the roasting pan. Toss them in the teaspoon of oil and\nsprinkle with a pinch of salt. Roast for 32 to 37 minutes, until carrots are fork-tender and\nblackened on the bottom.\n\n3. About 5 to 10 minutes before your carrots are done roasting, place the garlic and fresh\ndill into a large food processor. Process until minced.\n\n4. Drain the chickpeas over a small bowl, reserving the chickpea brine, if using.\n\n5. Next add the drained chickpeas, tahini, lemon juice, chickpea brine (or filtered water, if\nusing), oil, and salt. Process until smooth, stopping to scrape down the side ofthe\nprocessor as necessary.\n\n6. When the carrots are ready, carefully transport them to the processor using the\nparchment paper as a handle to carry. Process the mixture again until smooth. I like to let\nthe machine run for a couple minutes so it gets as smooth as possible. Taste and adjust\ningredients as desired. Feel free to add more dill, lemon, salt, oil or water depending on\nyour preferences.\n\n7. Serve the hummus with a sprinkle of ground cumin, coriander, and fresh minced dill, plus\na drizzle of sesame or olive oil, if desired. Leftover hummus will keep in an airtight\ncontainer in the fridge for about 5 to 7 days.\n\n")
//				semaphore.signal()
//			}
//			semaphore.wait()
//        }
//    }
	
}
