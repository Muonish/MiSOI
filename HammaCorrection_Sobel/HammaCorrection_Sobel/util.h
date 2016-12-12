/*
 *      Author: alexanderb
 */

#include <opencv2/opencv.hpp>

struct pointData { 
    float cornerResponse;

    cv::Point point;
};

struct by_cornerResponse { 
    bool operator()(pointData const &left, pointData const &right) { 
        return left.cornerResponse > right.cornerResponse;
    }
};

struct Derivatives {
    cv::Mat Ix;
    cv::Mat Iy;
    cv::Mat Ixy;
};

class Util {
public:
    static void DisplayMat(cv::Mat& img);
    static void DisplayPointVector(std::vector<cv::Point> vp);

    static cv::Mat MarkInImage(cv::Mat& img, std::vector<pointData> points, int radius);
};
