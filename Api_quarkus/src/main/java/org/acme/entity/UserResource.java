package org.acme.entity;

import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Path("/api/users")
public class UserResource {


    @GET
    @Path("/allusers")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllUsers() {
        List<User> userList = User.listAll();
        return Response.ok(userList).build();
    }

    @POST
    @Path("/signup")
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response signUp(User user) {
        if(User.findByName(user.getUsername())==null){
            User.persist(user);
            if (user.isPersistent()) {
                return Response.created(URI.create("/users/" + user.id)).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST).build();
            }
        }else {
            return Response.noContent().build();
        }
    }


    @POST
    @Path("/login")
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response Login(LoginRequest Login) {  //note errors
        User user = User.findByUsernameAndPassword(Login.getUsername(), Login.getPassword());
        if (user!=null) {
            return Response.ok(user).build();
        } else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }

    @PUT
    @Path("{id}")
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateUser(@PathParam("id") Long id, User updatedUser) {

        Optional<User> optionalUser = User.findByIdOptional(id);

        if (optionalUser.isPresent()) {
            User dbUser = optionalUser.get();

            if (Objects.nonNull(updatedUser.getUsername())) {
                dbUser.setUsername(updatedUser.getUsername());
            }
            if (Objects.nonNull(updatedUser.getPassword())) {
                dbUser.setPassword(updatedUser.getPassword());
            }
            if (Objects.nonNull(updatedUser.getAdmin())) {
            dbUser.setAdmin(updatedUser.getAdmin());
            }

            dbUser.persist();
            if (dbUser.isPersistent()) {
                return Response.ok(dbUser).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST).build();
            }

        } else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteUser(@PathParam("id") Long id) {
        boolean isDeleted = User.deleteById(id);
        User user = User.findById(id);
        if (isDeleted) {
            return Response.noContent().build();
        } else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }
}