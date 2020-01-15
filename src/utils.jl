rec_point(x::Vector{<: AbstractFloat}) = Point2f0(x)
rec_point(x) = rec_point.(x)

rec_project(source::Projection, dest::Projection, array) = rec_project.(source, dest, array)
rec_project(source::Projection, dest::Projection, point::Point2f0) = transform(source, dest, point)

"""
    grid_triangle_faces(lats, lons)

Returns a series of triangle indices from naive triangulation.
"""
function grid_triangle_faces(lons, lats)
    faces = Array{Int, 2}(undef, (length(lons)-1)*(length(lats)-1)*2, 3)

    xmax = length(lons)

    i = 1

    for lon in eachindex(lons)[1:end-1]
        for lat in eachindex(lats)[1:end-1]

            cpos = lon + (lat-1)*xmax

            faces[i, :] = [cpos, cpos+1, cpos+xmax+1]

            faces[i+1, :] = [cpos, cpos+xmax, cpos+xmax+1]

            i += 2

        end
    end

    return faces

end

"""
    gridpoints(xs, ys)

Returns a Vector of Points of a grid formed by xs and ys.
"""
gridpoints(xs, ys) = vec([Point2f0(x, y) for x in xs, y in ys])


const __TupTypes = Union{
                    Tuple{String, Any},
                    Tuple{String},
                    String
                }

function Proj4.Projection(args::Vector{<:__TupTypes})
    str = ""

    for arg in args
        if arg isa Tuple{String, T} where T <: Union{String, Real}
            opt, val = arg
            str *= " +$opt=$val"
        elseif arg isa Tuple{String} || arg isa Tuple{String, Nothing}
            opt = arg[1]
            str *= " +$opt"
        elseif arg isa String
            str *= " +$arg"
        end
    end

    return Projection(str)
end
