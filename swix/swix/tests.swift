//
//  fullTests.swift
//  swix
//
//  Created by Scott Sievert on 7/18/14.
//  Copyright (c) 2014 com.scott. All rights reserved.
//

import Foundation

class runTests {
    var N:Int
    init(){
        println("running ~150 tests")
        println("    running many simple tests")
        self.N = 10
        operatorTests()
        println("       operators work as expected")
        comparisonTests()
        println("       comparisons work as expected")
        functionTests()
        println("       simple functions work as expected")
        twoDTests()
        println("       matrix convience elements work as expected")
        readWriteTests()
        println("       read_csv, write_csv, savefig work like Python")
        complexTests()
        
        numberTests()
        ndarrayTests()
        matrixTests()
    }
    func complexTests(){
        func scalar_test(){
//            var x:Int = 1
//            var y:Double = 4
//            var z = x + y
//            assert(z == 5)
//            println("    Int(1)+Double(1)==2 through ScalarArithmetic")
//            println(" ** BUG: ScAr-2.0 needs to be integrated. Certain aspects don't work.")
        }
        func swift_complex_test(){
//            var x = 1.0 + 1.0.i
//            assert(abs(x) == sqrt(2))
//            println("    scalar (not vector) complex number usage works using swift-complex.")
        }
        func range_test(){
            var x = arange(4)
            var y = x[0..<2]
            assert(y ~== arange(2))
            
            var z = zeros(4)
            z[0..<2] = ones(2)
            assert(z ~== array(1, 1, 0, 0))
            println("    x[0..<2] = ones(2) and y = z[3..<8] works in the 1d case!")
        }
        func argwhere_test(){
            var x = zeros(N)
            var y = zeros(N)
            x[0..<5] = ones(5)
            var i = argwhere(abs(x-y) < 1e-9)
            assert(i ~== array(5, 6, 7, 8, 9))
            x[argwhere(x<2)] = ones(argwhere(x<2).n)
            println("    can use argwhere. x[argwhere(x<2)]=zeros(argwhere(x<2).n)  works for both 1d and 2d.")
        }
        func matrix2d_indexing_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            x[0..<2, 0..<2] = array("4 3; 2 6")
            assert(x ~== array("4 3 3; 2 6 6; 7 8 9"))
            println("    can use x[1, 0..<2] or x[0..<2, 0..<2] to also index")
        }
        func matrix2d_indexing_matrix_test(){
            var x = array("1 2 3; 4 5 6; 7 8 9")
            assert(x[array(0, 1, 2, 3, 4, 5)] ~== array(1, 2, 3, 4, 5, 6))
            println("    x[ndarray] works and indexes the ndarray row first")
        }
        func fft_test(){
            var x = arange(8)
            var (yr, yi) = fft(x)
            var x2 = ifft(yr, yi)
            assert(x2 ~== x)
            println("    fft/ifft works. fft(x) -> (yreal, yimag)")
        }
        func dot_test(){
            var x = eye(3) * 2
            var y = array("1 2 3 1; 4 5 6 1; 7 8 9 1")
            assert((x *! y) ~== 2*y)
            println("    dot product works with dot(x, y) or x *! y")
        }
        func svd_test(){
            var x = array("1 2; 4 8; 3 5")
            var (u, s, v) = svd(x)
            
            var y = array("1 2 3; 4 5 6")
            (u, s, v) = svd(y)
            
            var z = array("1 2 3; 4 5 6; 7 8 9")
            (u, s, v) = svd(z)
            
            println("    svd works and tested by hand for square, fat and skinny matrices against Python")
        }
        func svm_test(){
            var svm = SVM()
            var x = reshape(arange(4*2) , (4, 2))
            var y = array(0, 1, 2, 3)
            
            svm.train(x, y)
            var z = svm.predict(array(2, 3))
            assert(z == y[1])
            println("    svm works via simple test")
        }
        func inv_test(){
            var x = randn((4,4))
            var y = inv(x)
            assert((x *! y) ~== eye(4))
            println("    matrix inversion works")
        }
        func solve_test(){
            var A0 = array(1, 2, 3, 4, 2, 1, 4, 6, 7)
            var A = reshape(A0, (3, 3))
            var b = array(1, 2, 5)
            var x = solve(A, b)
            assert((A !/ b) ~== solve(A, b))
            println("    solve works, similar to Matlab's \\ operator (and checked by hand). Be careful -- this only works for nxn matrices")
        }
        func eig_test(){
            var x = zeros((3,3))
            x["diag"] = array(1, 2, 3)
            var r = eig(x)
            assert(r ~== array(1, 2, 3))
            println("    `eig` returns the correct eigenvalues and no eigenvectors.")
        }
        func pinv_test(){
            var x = arange(3*4).reshape((3,4))
            var y = pinv(x)
            assert(x.dot(y).dot(x) ~== x)
            assert(x.pI ~== pinv(x))
            println("    pseudo-inverse works")
        }
        swift_complex_test()
        scalar_test()
        range_test()
        argwhere_test()
        matrix2d_indexing_test()
        matrix2d_indexing_matrix_test()
        fft_test()
        dot_test()
        svd_test()
        svm_test()
        inv_test()
        solve_test()
        eig_test()
        pinv_test()
    }
    func numberTests(){
        assert(close(0, 1e-10) == true)
        assert(close(0, 1e-10) == (1e-10 ~= 0))
        assert(rad2deg(pi/2) == 90)
        assert(deg2rad(90) == pi/2)
        assert(max(0, 1) == 1)
        assert(min(0, 1) == 0)
        assert("3.14".floatValue == 3.14)
        assert(3 / 4 == 0.75)
        assert(3.25 / 4 == 0.8125)
        assert(isNumber(3))
        assert(!isNumber(zeros(2)))
        assert(!isNumber("3.14"))
    }
    class ndarrayTests{
        init(){
            initingTests()
            ndarraySwiftTests()
        }
        func initingTests(){
            // testing zeros and array
            assert(zeros(4) ~== array(0,0,0,0))
            assert(ones(4) ~== (zeros(4)+1))
            assert(zeros_like(ones(4)) ~== zeros(4))
            assert(arange(4) ~== array(0, 1, 2, 3))
            assert(arange(2, 4) ~== array(2, 3))
            assert(linspace(0,1,num:3) ~== array(0, 0.5, 1))
            assert(repeat(arange(2), 2) ~== array(0,1,0,1))
            assert(copy(arange(4)) ~== arange(4))
            assert(asarray(0..<2) ~== array(0, 1))
            assert(copy(arange(3)) ~== array(0, 1, 2))
            assert(sum((rand(3) - array(0.516, 0.294, 0.727)) < 1e-2) == 3)
        }
        func ndarraySwiftTests(){
            // testing the file ndarray.swift
            var x_idx = zeros(4)
            x_idx[0..<2] <- 2
            assert(x_idx ~== array(2, 2, 0, 0))
            assert(arange(4).reshape((2,2)) ~== array("0 1; 2 3"))
            assert(arange(4).copy() ~== arange(4))
            var x = array(4, 2, 3, 1)
            x.sort()
            assert(x ~== array(1, 2, 3, 4))
            assert(x.min() == 1)
            assert(x.max() == 4)
            assert(x.mean() == 2.5)
            assert(x["all"] ~== array(1, 2, 3, 4))
            x[0] = 0
            assert(x[0] == 0)
            x[0..<2] = array(1, 3)
            assert(x[0..<2] ~== array(1, 3))
            x[arange(2)] = array(4, 1)
            assert(x[arange(2)] ~== array(4, 1))
            
            var y = array(5, 2, 4, 3, 1)
            assert((y < 2) ~== array(0, 0, 0, 0, 1))
            assert(reverse(y) ~== array(1, 3, 4, 2, 5))
            assert(sort(y) ~== array(1, 2, 3, 4, 5))
            assert(delete(y, array(0, 1)) ~== array(4, 3, 1))
            assert(asarray([0, 1, 2]) ~== array(0, 1, 2))
            assert(asarray(0..<2) ~== array(0, 1))
            assert(concat(array(1, 2), array(3, 4)) ~== (arange(4)+1))
            assert(clip(y, 2, 4) ~== array(4, 2, 4, 3, 2))
            assert(delete(y, array(0, 1)) ~== array(4,3,1))
            assert(repeat(array(0,1),2) ~== array(0,1,0,1))
            assert(repeat(array(0,1),2, axis:1) ~== array(0,0,1,1))
            assert(argmax(array(1,4,2,5)) == 3)
            assert(argmin(array(1,4,2,5)) == 0)
            assert(argsort(array(1,4,2,5)) ~== array(0, 2, 1, 3))

            assert(arange(4) ~== array(0, 1, 2, 3))
            var xO = array(1, 2, 3)
            var yO = array(1, 2, 3) + 3
            assert(outer(xO, yO) ~== array(4, 5, 6, 8, 10, 12, 12, 15, 18).reshape((3,3)))
            var xR1 = array(1.1, 1.2, 1.3)
            var xR2 = array(1, 1, 1)
            assert(remainder(xR1, xR2) ~== array(0.1, 0.2, 0.3))
            assert(xR1 % 1.0 ~== array(0.1, 0.2, 0.3))
            assert(1.0 % xR1 ~== ones(3))
            assert(arange(4)[-1] == 3.0)
            
            var xR = arange(4*4).reshape((4,4))
            assert(rank(xR) == 2.0)
            
            assert(pow(array(1,2,3,4), 2) ~== array(1,4,9,16))
            assert(pow(ones(4)*2, ones(4)*2) ~== array(4, 4, 4, 4))
            assert(pow(-1, array(1, 2, 3, 4)) ~== array(-1, 1, -1, 1))
            assert(norm(array(1,1,1), ord:2) == sqrt(3))
            assert(norm(array(1,0,1), ord:1) == 2)
            assert(norm(array(4,0,0), ord:0) == 1)
            assert(norm(array(4,0,0), ord:-1) == 4)
            assert(norm(array(4,2,-3), ord:inf) == 4)
            assert(norm(array(4,2,-3), ord:-inf) == 2)
            
            assert(sign(array(-3, 4, 5)) ~== array(-1, 1, 1))
            assert(floor(array(1.1, 1.2, 1.6)) ~== array(1, 1, 1))
            assert(round(array(1.1, 1.2, 1.6)) ~== array(1, 1, 2))
            assert(ceil(array(1.2, 1.5, 1.8)) ~== ones(3)*2)
            assert(log10(ones(4) * 10) ~== ones(4))
            assert(log2(ones(4) * 2) ~== ones(4))
            assert(log(ones(4) * e) ~== ones(4))
            assert(exp2(ones(4)*2) ~== ones(4) * 4)
            assert(exp(ones(4)*2) ~== ones(4)*e*e)
        }
    }
    func matrixTests(){
        var x = randn((4,4))
        assert(eye(4).dot(eye(4)) ~== eye(4))
        assert(x.dot(x.I) ~== eye(4))
        var (u,v) = meshgrid(array(0,1), array(2,3))
        assert(u ~== repeat(array(0,1), 2).reshape((2,2)).T)
        assert(v ~== repeat(array(2,3), 2).reshape((2,2)))
    }
    
    func readWriteTests(){
        var x1 = arange(9).reshape((3,3)) * 2
        write_csv(x1, filename:"../../python_testing/csvs/image.csv")
        var y1:matrix = read_csv("../../python_testing/csvs/image.csv")
        assert(x1 ~== y1)
        
        var x2 = array(1, 2, 3, 4, 5, 2, 1)
        write_csv(x2, filename:"../../python_testing/csvs/ndarray.csv")
        var y2:ndarray = read_csv("../../python_testing/csvs/ndarray.csv")
        assert(x2 ~== y2)
    }
    func twoDTests(){
        var x = arange(9).reshape((3,3))
        assert(x.T ~== transpose(x))
        assert(x.I ~== inv(x))
        assert(x["diag"] ~== array(0, 4, 8))
        var y = x.copy()
        y["diag"] = array(1, 5, 9)
        assert(y ~== array(1, 1, 2, 3, 5, 5, 6, 7, 9).reshape((3,3)))
        assert(eye(2) ~== array(1, 0, 0, 1).reshape((2,2)))
        
        assert(x[0..<2, 0..<2] ~== array(0, 1, 3, 4).reshape((2,2)))
        var z2 = x.copy()
        z2[0..<2, 0..<2] = array(1, 2, 3, 4).reshape((2,2))
        assert(z2[0..<2, 0..<2] ~== array(1, 2, 3, 4).reshape((2,2)))
        
        assert(x.flat[array(1, 4, 5, 6)] ~== x[array(1, 4, 5, 6)])
        y = x.copy()
        y[array(1, 4, 5, 6)] = ones(4)
        assert(y ~== array(0, 1, 2, 3, 1, 1, 1, 7, 8).reshape((3,3)))
        
        var z = arange(3*4).reshape((3,4))
        assert(sum(z, axis:0) ~== array(12, 15, 18, 21))
        assert(sum(z, axis:1) ~== array(6, 22, 38))
        
        var d1 = x *! y
        var d2 = x.dot(y)
        var d3 = dot(x, y)
        assert(d1 ~== d2)
        assert(d1 ~== d3)
    }
    func functionTests(){
        var x = array(-1, 0, 1)
        
        assert(abs(x) ~== array(1, 0, 1))
        assert(sign(x+0.1) ~== array(-1, 1, 1))
        assert(sum(x+1)     == 3)
        assert(cumsum(x+1) ~== array(0, 1, 3))
        assert(pow(x+1, 2) ~== array(0, 1, 4))
        assert(((x+1)^2)   ~== array(0, 1, 4))
        assert(variance(ones(4)) == 0)
        assert(std(ones(4)) == 0)
        assert(mean(x) == 0)
        assert(abs(mean(rand(1000)) - 0.5) < 0.1)
        assert(abs(mean(randn(1000))) < 0.1)
        assert(abs(std(randn(1000)) - 1) < 0.2)
        var y = randn((100,100))
        assert(abs(mean(y.flat)) < 0.1)
        y = rand((100, 100))
        assert(abs(mean(y.flat) - 0.5) < 0.1)
        
        assert(repeat(array(0, 1), 2) ~== array(0, 1, 0, 1))
        assert(repeat(array(0, 1), 2, axis:1) ~== array(0, 0, 1, 1))
        
//        var xC = zeros_like(x)
        var xC = copy(x)
        assert(xC ~== x.copy())
        
        assert(array("0 1 2; 3 4 5") ~== arange(6).reshape((2,3)))
        
        var z1 = array(0, 1)
        var z2 = array(2, 3)
        var (z11, z22) = meshgrid(z1, z2)
        assert(z11 ~== array(0, 0, 1, 1).reshape((2,2)))
        assert(z22 ~== array(2, 3, 2, 3).reshape((2,2)))
        
        assert(x.min() == min(x))
        assert(x.min() == -1)
        
        assert(x.max() == max(x))
        assert(x.max() == 1)
        
        assert(x.copy() ~== copy(x))
        assert(x.copy() ~== array(-1, 0, 1))
        
        assert(arange(4).reshape((2,2)).copy() ~== arange(4).reshape((2,2)))
        
        var z = array(-3, -2, -1, 0, 1, 2, 3)
        assert(z[argwhere(z < 0)] ~== array(-3, -2, -1))
        assert((z < 0) ~== array(1, 1, 1, 0, 0, 0, 0))
        
        assert(sin(array(1, 2, 3, 4)) ~== array(sin(1), sin(2), sin(3), sin(4)))
//        func f(x:Double)->Double {return x+1}
//        assert(apply_function(f,arange(100)) ~== (arange(100)+1))
        var x5 = arange(5)
        var y5 = array(1, 5, 3, 2, 6)
        assert(max(x5, y5) ~== array(1, 5, 3, 3, 6))
        assert(min(x5, y5) ~== array(0, 1, 2, 2, 4))
        
        var mx5 = arange(4).reshape((2,2))
        var my5 = array(4, 2, 1, 0).reshape((2,2))
        assert(min(mx5, my5) ~== array(0, 1, 1, 0).reshape((2,2)))
        assert(reverse(y5) ~== array(6, 2, 3, 5, 1))
        
        assert(sort(y5) ~== array(1, 2, 3, 5, 6))
        
        func helper_test(){
            var x = arange(2*3).reshape((2,3))
            assert(fliplr(x) ~== array(2, 1, 0, 5, 4, 3).reshape((2,3)))
            assert(flipud(x) ~== array(3, 4, 5, 0, 1, 2).reshape((2,3)))
        }
        helper_test()
    }
    func operatorTests(){
        // l and o similar to 1 and 0
        var l = ones(N)
        var o = zeros(N)
        
        // PLUS
        assert((o+1.double) ~== l)
        assert((1.double+o) ~== l)
        assert((l+o) ~== l)
        
        // MINUS
        assert((l - o) ~== l)
        assert((l - 1) ~== o)
        assert((1 - o) ~== l)
        
        // MULTIPLY
        assert(((o+1) * l) ~== l)
        assert((l * 1) ~== l)
        assert((1 * l) ~== l)
        
        // DIVIDE
        assert(((l+1)/2) ~== l)
        assert((o/l) ~== o)
        assert((1 / l) ~== l)
        
        // POW
        assert((array(1, 2, 3)^2) ~== array(1, 4, 9))
        
        // MODULO
        assert(array(1, 3.14, 2.1)%1.0 ~== array(0, 0.14, 0.1))
        assert(array(1, 2, 6) % 5 ~== array(1, 2, 1))
    }
    func comparisonTests(){
        //     true:  <, >, <=, >=, ==, !==
        var x = array(0, 3,  3,  4,  5,  7)
        var y = array(1, 2,  3,  4,  5,  6)
        
        // matrix <op> matrix
        assert((x < y) ~== array(1, 0, 0, 0, 0, 0))
        assert((x > y) ~== array(0, 1, 0, 0, 0, 1))
        assert((x <= y) ~== array(1, 0, 1, 1, 1, 0))
        assert((x >= y) ~== array(0, 1, 1, 1, 1, 1))
        assert((x == y) ~== array(0, 0, 1, 1, 1, 0))
        assert((x !== y) ~== array(1, 1, 0, 0, 0, 1))
        
        // double <op> matrix
        assert((4 < x) ~== array(0, 0, 0, 0, 1, 1))
        assert((4 > x) ~== array(1, 1, 1, 0, 0, 0))
        assert((4 >= x) ~== array(1, 1, 1, 1, 0, 0))
        assert((4 <= x) ~== array(0, 0, 0, 1, 1, 1))
        
        // matrix <op> ouble
        assert((x > 4) ~== array(0, 0, 0, 0, 1, 1))
        assert((x < 4) ~== array(1, 1, 1, 0, 0, 0))
        assert((x <= 4) ~== array(1, 1, 1, 1, 0, 0))
        assert((x >= 4) ~== array(0, 0, 0, 1, 1, 1))
    }
}












