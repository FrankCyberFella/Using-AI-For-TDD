package workshop.exercise2;

public class DefaultPasswordValidator implements PasswordValidator {
    @Override
    public boolean validate(String password) {
        return false;
    }
}
