/*
 *      Author: alexanderb
 */

#include <opencv2/opencv.hpp>

#include "util.h"

class Harris {
public:
    Harris(cv::Mat img, float k, int filterRange, bool gauss);
    std::vector<pointData> getMaximaPoints(float percentage, int filterRange, int suppressionRadius);

private:
    cv::Mat convertRgbToGrayscale(cv::Mat& img);
    Derivatives computeDerivatives(cv::Mat& greyscaleImg);
	Derivatives applyMeanToDerivatives(Derivatives& dMats, int filterRange);
	Derivatives applyGaussToDerivatives(Derivatives& dMats, int filterRange);
    cv::Mat computeHarrisResponses(float k, Derivatives& intMats);

    cv::Mat computeIntegralImg(cv::Mat& img);
    cv::Mat meanFilter(cv::Mat& intImg, int range);
    cv::Mat gaussFilter(cv::Mat& img, int range);

private:
    cv::Mat m_harrisResponses;
};
