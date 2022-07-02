module main

import math


struct Vector {
mut: 
	x	f32
	y 	f32
}

fn (mut vector Vector) set(rad f32, mag f32) Vector {
    vector.x = f32(math.cos(rad) * mag)
    vector.y = f32(math.sin(rad) * mag)
    return vector
}

fn (mut vector Vector) limit(limit f32) {
    if vector.mag() > limit  {
        vector.set_mag(limit)
    }
}

fn (mut vector Vector) mag() f64 {
	return math.sqrt(vector.x * vector.x + vector.y * vector.y)
}

fn (mut vector Vector) set_mag(mag f64) Vector{
    angle := vector.heading()
    vector.x = f32(math.cos(angle) * mag)
    vector.y = f32(math.sin(angle) * mag)
    return vector
}

fn (mut vector Vector) dist(vector2 Vector) f64 {
	x := vector.x - vector2.x
	y := vector.y - vector2.y
	return math.sqrt(x * x + y * y)
}

fn (mut vector Vector) sub(vector2 Vector) Vector {
	vector.x -= vector2.x
	vector.y -= vector2.y
	return vector
}

fn (mut vector Vector) add(vector2 Vector) Vector {
	vector.x += vector2.x
	vector.y += vector2.y
	return vector
}

fn (mut vector Vector) mul(vector2 Vector) Vector {
	vector.x *= vector2.x
	vector.y *= vector2.y
	return vector
}

fn (mut vector Vector) heading() f64 {
    tau := math.tau * 2

    if vector.x == 0 && vector.y > 0 {
        return math.pi / 2
    }
    if vector.x == 0 && vector.y <= 0 {
        return math.pi * 3 / 2
    }
    if vector.x > 0 {
        return math.fmod(tau + math.atan(vector.y / vector.x), tau)
    }
    if vector.x < 0 {
        return math.pi + math.atan(vector.y / vector.x)
    }

    return -1.0
}