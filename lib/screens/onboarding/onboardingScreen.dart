import 'package:flutter/material.dart';
import 'package:mybeautyadvisor/app_localizations.dart';
import 'package:mybeautyadvisor/components/defaultButton.dart';
import 'package:mybeautyadvisor/constants/consts.dart';
import 'package:mybeautyadvisor/tools/myNavigator.dart';
import 'package:mybeautyadvisor/tools/sizeConfig.dart';
import 'components/boardView.dart';
import 'components/indicator.dart';


// Constants
const double    SELFIE_IMGS_BORDER_RADIUS = 10;
const int       NBR_PAGES = 4;



class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController    _pageController = PageController(initialPage: 0);
  int               _currentPage = 0;
  
  //  Page index methods ///////////////////////////////////////////////////////////////
  List<Widget>        _buildPageIndicator() {
    List<Widget>  widgetList = [];
    for (int i=0; i < NBR_PAGES; i++)
      widgetList.add(i == _currentPage ? indicator(true) : indicator(false));
    return widgetList;
  }

  void               _changePage(int pageIndex) {
    setState(() {
      _currentPage = pageIndex;
    });
  }

  void               _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  /////////////////////////////////////////////////////////////////////////////////////

  //  Get Started  ////////////////////////////////////////////////////////////////////
  void            getStarted() {
     MyNavigator.goHome(context);
  }
  /////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: kPrimaryGradientColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              // Skip Button
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: getStarted,
                  child: Text(
                    AppLocalizations.of(context).translate('selfie_skip'),
                    style: Theme.of(context).textTheme.headline2.copyWith(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),


              //// Body
              Expanded(
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: _changePage,
                  children: <Widget> [

                    //// First View
                    BoardView(
                      children: <Widget>[
                        // Image
                        Center(
                          child: Image(
                            image: AssetImage('assets/images/onboarding/onboarding0.png'),
                            height: getProportionateScreenHeight(220),
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(50)),      
                        // Title
                        Text(
                          AppLocalizations.of(context).translate('onboarding_0-title'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            height: 1.6,
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(30)),       
                        // Subtitle
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black87,
                              fontSize: 20,
                              height: 1.6,
                            ),
                            children: <TextSpan> [
                              TextSpan(
                                text: 'MybeautyAdvisor ',
                                style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: 20,
                                  height: 1.6,
                                  color: kPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context).translate('onboarding_0-subtitle'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //// Second View
                    BoardView(
                      children: <Widget>[
                        // Title
                        Text(
                          AppLocalizations.of(context).translate('onboarding_1-title'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            height: 1.6,
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(30)),       
                        // Subtitle
                        Text(
                          AppLocalizations.of(context).translate('onboarding_1-subtitle'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            height: 1.6,
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(50)),  
                        // Images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget> [
                            // OK
                            Column(
                              children: <Widget> [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(SELFIE_IMGS_BORDER_RADIUS),
                                  child: Image.asset(
                                    'assets/images/onboarding/1/image_bad.png',
                                    width: SizeConfig.screenWidth * 0.3,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(SELFIE_IMGS_BORDER_RADIUS),
                                  child: Image.asset(
                                    'assets/images/onboarding/1/bad.png',
                                    width: SizeConfig.screenWidth * 0.1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: SizeConfig.screenWidth * 0.1),
                            // No
                            Column(
                              children: <Widget> [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(SELFIE_IMGS_BORDER_RADIUS),
                                  child: Image.asset(
                                    'assets/images/onboarding/1/image_good.jpg',
                                    width: SizeConfig.screenWidth * 0.3,
                                  ),
                                ),
                                SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(SELFIE_IMGS_BORDER_RADIUS),
                                  child: Image.asset(
                                    'assets/images/onboarding/1/good.png',
                                    width: SizeConfig.screenWidth * 0.1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    //// Third View
                    BoardView(
                      children: <Widget>[
                        // Title
                        Text(
                          AppLocalizations.of(context).translate('onboarding_2-title'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            height: 1.6,
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(30)),       
                        // Body
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              // Text
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget> [
                                  Text(
                                    AppLocalizations.of(context).translate('onboarding_2-subtitle-brand'),
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      height: 2,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).translate('onboarding_2-subtitle-name'),
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      height: 2,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).translate('onboarding_2-subtitle-shade'),
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Image
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/onboarding/2.jpg',
                                  width: SizeConfig.screenWidth * 0.35,
                                ),
                              ),
                            ),
                          ],
                        ),   
                      ],
                    ),

                    //// Fourth View
                    BoardView(
                      children: <Widget>[
                        // Image
                        Center(
                          child: Image(
                            image: AssetImage('assets/images/onboarding/3.png'),
                            height: SizeConfig.screenHeight * 0.2,
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(50)),      
                        // Title
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black87,
                              fontSize: 20,
                              height: 1.6,
                            ),
                            children: <TextSpan> [
                              TextSpan(
                                text: AppLocalizations.of(context).translate('onboarding_3-title-1'),
                              ),
                              TextSpan(
                                text: ' MybeautyAdvisor',
                                style: Theme.of(context).textTheme.headline2.copyWith(
                                  fontSize: 20,
                                  color: kPrimaryColor,
                                ),
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context).translate('onboarding_3-title-2'),
                              ),
                            ],
                          ),
                        ),
                        // Space
                        SizedBox(height: getProportionateScreenHeight(30)),       
                        // Subtitle
                        Text(
                          AppLocalizations.of(context).translate('onboarding_3-subtitle'),
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                            color: Colors.black87,
                            fontSize: 20,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              //// Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),

              //// Next Button
              ( _currentPage != NBR_PAGES-1 ) ?
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child:GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: kPrimaryColor
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.all(10).copyWith(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget> [
                            Text(
                              AppLocalizations.of(context).translate('onboarding_next'),
                              style: Theme.of(context).textTheme.headline2.copyWith(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                      onTap: _nextPage,
                    ),
                  ),
                ) :
                Text(''),

                // Get started
                ( _currentPage == NBR_PAGES-1 ) ?
                  DefaultButton(
                    text: AppLocalizations.of(context).translate('onboarding_get-started'),
                    width: getProportionateScreenWidth(150),
                    press: getStarted,
                  ) :
                  Text(''),

            ],
          )
        ),
      ),
    );
  }
}
